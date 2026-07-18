import Foundation
import UIKit
import Vision

/// Analyzes an uploaded image using Apple's on-device Vision ML
/// to detect objects, scenes, and text — then builds a dynamic itinerary.
final class ImageAnalysisService {
    
    // MARK: - Public API
    
    /// Analyzes an image and returns a list of TimelineBlocks for the itinerary.
    func analyze(image: UIImage) async throws -> [TimelineBlock] {
        // Downscale to prevent memory crash on large photos (48MP+)
        let resized = resizeImage(image, maxDimension: 1024)
        
        guard let cgImage = resized.cgImage else {
            throw AnalysisError.invalidImage
        }
        
        // Run OCR first (most reliable)
        let text = try await recognizeText(in: cgImage)
        
        // Then classification (can fail/cancel — non-fatal)
        var labels: [String] = []
        do {
            labels = try await classifyImage(cgImage)
        } catch {
            print("⚠️ Image classification failed (non-fatal): \(error.localizedDescription)")
            // Continue with OCR results only
        }
        
        // Build the itinerary from detected content
        return buildItinerary(labels: labels, ocrText: text)
    }
    
    // MARK: - Image Resizing
    
    /// Resizes image to fit within maxDimension while preserving aspect ratio.
    private func resizeImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        let size = image.size
        guard max(size.width, size.height) > maxDimension else { return image }
        
        let scale = maxDimension / max(size.width, size.height)
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    // MARK: - Vision Classification
    
    private func classifyImage(_ cgImage: CGImage) async throws -> [String] {
        try await withCheckedThrowingContinuation { continuation in
            // Guard against double-resume: perform() is synchronous and calls
            // the completion handler during execution. If it also throws,
            // the catch block would resume a second time → crash.
            var hasResumed = false
            
            let request = VNClassifyImageRequest { request, error in
                guard !hasResumed else { return }
                hasResumed = true
                
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let results = request.results as? [VNClassificationObservation] else {
                    continuation.resume(returning: [])
                    return
                }
                
                // Get labels with reasonable confidence
                let labels = results
                    .filter { $0.confidence > 0.3 }
                    .prefix(15)
                    .map { $0.identifier.replacingOccurrences(of: "_", with: " ").capitalized }
                
                continuation.resume(returning: Array(labels))
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                guard !hasResumed else { return }
                hasResumed = true
                continuation.resume(throwing: error)
            }
        }
    }
    
    // MARK: - OCR Text Recognition
    
    private func recognizeText(in cgImage: CGImage) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            var hasResumed = false
            
            let request = VNRecognizeTextRequest { request, error in
                guard !hasResumed else { return }
                hasResumed = true
                
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(returning: "")
                    return
                }
                
                let strings = observations.compactMap { obs in
                    obs.topCandidates(1).first?.string
                }.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                
                continuation.resume(returning: strings.joined(separator: "\n"))
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                guard !hasResumed else { return }
                hasResumed = true
                continuation.resume(throwing: error)
            }
        }
    }
    
    // MARK: - Itinerary Builder
    
    /// Maps detected labels and OCR text into a structured itinerary.
    private func buildItinerary(labels: [String], ocrText: String) -> [TimelineBlock] {
        let combined = (labels + ocrText.components(separatedBy: .newlines))
            .map { $0.lowercased() }
        
        var blocks: [TimelineBlock] = []
        
        // Detect food-related content
        let foodKeywords = ["food", "restaurant", "meal", "dining", "pizza", "burger", "coffee", "cafe", "bakery", "dessert", "salad", "pasta", "noodle", "rice", "bread", "cake", "plate", "bowl", "cup", "drink", "juice", "smoothie", "ice cream", "sushi", "curry", "biryani", "dosa", "thali", "brunch"]
        let hasFood = combined.contains { text in foodKeywords.contains(where: { text.contains($0) }) }
        
        // Detect activity-related content
        let activityKeywords = ["bowling", "arcade", "gaming", "paintball", "sport", "adventure", "movie", "cinema", "theater", "concert", "park", "garden", "museum", "gallery", "gym", "fitness", "yoga", "spa", "pool", "swimming", "hiking", "cycling", "skating", "karting", "escape room", "laser tag", "trampoline"]
        let hasActivity = combined.contains { text in activityKeywords.contains(where: { text.contains($0) }) }
        
        // Detect outdoor/nature content
        let outdoorKeywords = ["outdoor", "nature", "tree", "mountain", "lake", "river", "beach", "sky", "sunset", "sunrise", "garden", "flower", "grass", "landscape", "scenic"]
        let hasOutdoor = combined.contains { text in outdoorKeywords.contains(where: { text.contains($0) }) }
        
        // Detect nightlife content
        let nightlifeKeywords = ["bar", "pub", "club", "nightlife", "cocktail", "beer", "wine", "lounge", "rooftop", "party"]
        let hasNightlife = combined.contains { text in nightlifeKeywords.contains(where: { text.contains($0) }) }
        
        // Detect shopping content
        let shoppingKeywords = ["shop", "mall", "store", "market", "fashion", "clothing", "boutique", "retail"]
        let hasShopping = combined.contains { text in shoppingKeywords.contains(where: { text.contains($0) }) }
        
        // Extract venue names from OCR (lines that look like proper nouns)
        let venueNames = ocrText.components(separatedBy: .newlines)
            .filter { line in
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                return trimmed.count > 2 && trimmed.count < 40 && trimmed.first?.isUppercase == true
            }
        
        // Build timeline based on what was detected
        var hour = 10
        
        // Morning block
        if hasFood {
            let venueName = venueNames.first ?? "Detected Restaurant"
            blocks.append(TimelineBlock(
                time: formatTime(hour),
                title: "Breakfast",
                icon: "🥞",
                items: [
                    Activity(name: venueName, rating: "4.7", distance: "1.5 km", price: nil, image: "cafe", tags: detectTags(from: combined, category: "food"))
                ]
            ))
            hour += 2
        } else {
            blocks.append(TimelineBlock(
                time: formatTime(hour),
                title: "Breakfast",
                icon: "🥞",
                items: [
                    Activity(name: "Morning Cafe", rating: "4.5", distance: "1.2 km", price: nil, image: "cafe", tags: ["Cozy", "Pastries"])
                ]
            ))
            hour += 2
        }
        
        // Activity block
        if hasActivity || hasOutdoor {
            let activityName = detectActivityName(from: combined)
            blocks.append(TimelineBlock(
                time: formatTime(hour),
                title: activityName,
                icon: hasOutdoor ? "🏞️" : "🎯",
                items: [
                    Activity(name: venueNames.count > 1 ? venueNames[1] : "\(activityName) Arena", rating: "4.8", distance: "3.5 km", price: "₹1200", image: "activity", tags: detectTags(from: combined, category: "activity"))
                ]
            ))
            hour += 2
        } else {
            blocks.append(TimelineBlock(
                time: formatTime(hour),
                title: "Explore",
                icon: "🗺️",
                items: [
                    Activity(name: "Local Exploration", rating: "4.6", distance: "2.0 km", price: "₹500", image: "explore", tags: Array(labels.prefix(2)))
                ]
            ))
            hour += 2
        }
        
        // Lunch
        blocks.append(TimelineBlock(
            time: formatTime(hour),
            title: "Lunch",
            icon: "🥗",
            items: [
                Activity(name: venueNames.count > 2 ? venueNames[2] : "Local Bistro", rating: "4.7", distance: "1.0 km", price: nil, image: "lunch", tags: hasFood ? detectTags(from: combined, category: "food") : ["Popular", "Affordable"])
            ]
        ))
        hour += 2
        
        // Afternoon activity or shopping
        if hasShopping {
            blocks.append(TimelineBlock(
                time: formatTime(hour),
                title: "Shopping",
                icon: "🛍️",
                items: [
                    Activity(name: venueNames.count > 3 ? venueNames[3] : "Shopping Mall", rating: "4.5", distance: "2.5 km", price: nil, image: "shopping", tags: ["Trending", "Fashion"])
                ]
            ))
            hour += 2
        } else {
            blocks.append(TimelineBlock(
                time: formatTime(hour),
                title: "Cafe Break",
                icon: "☕",
                items: [
                    Activity(name: "Artisan Cafe", rating: "4.8", distance: "0.8 km", price: nil, image: "coffee", tags: ["Artisan", "Quiet"])
                ]
            ))
            hour += 2
        }
        
        // Evening/Dinner
        if hasNightlife {
            blocks.append(TimelineBlock(
                time: formatTime(hour),
                title: "Evening Out",
                icon: "🍷",
                items: [
                    Activity(name: venueNames.last ?? "Rooftop Lounge", rating: "4.9", distance: "3.0 km", price: "₹2000", image: "nightlife", tags: ["Rooftop", "Cocktails"])
                ]
            ))
        } else {
            blocks.append(TimelineBlock(
                time: formatTime(hour),
                title: "Dinner",
                icon: "🍽️",
                items: [
                    Activity(name: venueNames.last ?? "Fine Dining", rating: "4.9", distance: "2.5 km", price: nil, image: "dinner", tags: ["Popular", "Must-Try"])
                ]
            ))
        }
        
        // If we detected very little, add detected labels as tags to first item
        if blocks.count < 3 {
            blocks.insert(TimelineBlock(
                time: "12:00 PM",
                title: "Recommended",
                icon: "✨",
                items: [
                    Activity(name: "AI Recommendation", rating: "4.7", distance: "2.0 km", price: nil, image: "recommend", tags: Array(labels.prefix(3)))
                ]
            ), at: 1)
        }
        
        return blocks
    }
    
    // MARK: - Helpers
    
    private func formatTime(_ hour: Int) -> String {
        let h = hour % 12 == 0 ? 12 : hour % 12
        let period = hour >= 12 ? "PM" : "AM"
        return "\(h):00 \(period)"
    }
    
    private func detectActivityName(from combined: [String]) -> String {
        let activities = ["bowling", "paintball", "arcade", "movies", "skating", "karting", "swimming", "hiking", "yoga", "spa", "cycling"]
        for activity in activities {
            if combined.contains(where: { $0.contains(activity) }) {
                return activity.capitalized
            }
        }
        return "Adventure"
    }
    
    private func detectTags(from combined: [String], category: String) -> [String] {
        var tags: [String] = []
        
        switch category {
        case "food":
            let foodTags = ["Italian", "Indian", "Chinese", "Mexican", "Japanese", "Thai", "Healthy", "Vegan", "Organic", "Street Food", "Fine Dining", "Cafe"]
            for tag in foodTags {
                if combined.contains(where: { $0.contains(tag.lowercased()) }) {
                    tags.append(tag)
                }
            }
        case "activity":
            let activityTags = ["Top Rated", "Indoor", "Outdoor", "Family", "Adventure", "Relaxing"]
            for tag in activityTags {
                if combined.contains(where: { $0.contains(tag.lowercased()) }) {
                    tags.append(tag)
                }
            }
        default:
            break
        }
        
        if tags.isEmpty {
            tags = category == "food" ? ["Popular", "Must-Try"] : ["Fun", "Top Rated"]
        }
        
        return Array(tags.prefix(3))
    }
    
    // MARK: - Errors
    
    enum AnalysisError: LocalizedError {
        case invalidImage
        case analysisFailed
        
        var errorDescription: String? {
            switch self {
            case .invalidImage: return "Could not process the selected image."
            case .analysisFailed: return "Image analysis failed."
            }
        }
    }
}
