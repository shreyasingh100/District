import SwiftUI

struct TextProcessingScreen: View {
    let primaryColor = Color(red: 184/255, green: 164/255, blue: 248/255)
    let planText: String
    
    @State private var statusText: String = "Reading your plan..."
    @State private var statusEmoji: String = "📖"
    @State private var progress: Double = 0.0
    @State private var isNavigating = false
    @State private var parsedTimeline: [TimelineBlock] = []
    
    // Animated dots
    @State private var dotCount: Int = 0
    @State private var glowOpacity: Double = 0.3
    @State private var iconRotation: Double = 0
    @State private var iconScale: Double = 1.0
    
    private let parser = TextParserService()
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Animated AI Icon
            ZStack {
                // Glow rings
                Circle()
                    .fill(primaryColor.opacity(glowOpacity * 0.3))
                    .frame(width: 160, height: 160)
                
                Circle()
                    .fill(primaryColor.opacity(glowOpacity * 0.5))
                    .frame(width: 120, height: 120)
                
                Circle()
                    .fill(primaryColor.opacity(glowOpacity))
                    .frame(width: 80, height: 80)
                
                // Center icon
                Text(statusEmoji)
                    .font(.system(size: 40))
                    .scaleEffect(iconScale)
                    .rotationEffect(.degrees(iconRotation))
            }
            .padding(.bottom, 48)
            
            // Status text with animated dots
            Text(statusText)
                .font(.system(size: 26, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.3), value: statusText)
            
            // Subtitle
            Text("Our AI is crafting your perfect day")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .padding(.top, 8)
                .padding(.horizontal, 32)
            
            // Progress bar
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 240, height: 6)
                
                Capsule()
                    .fill(
                        LinearGradient(colors: [primaryColor, Color.purple], startPoint: .leading, endPoint: .trailing)
                    )
                    .frame(width: 240 * (progress / 100), height: 6)
                    .animation(.easeInOut(duration: 0.6), value: progress)
            }
            .padding(.top, 32)
            
            // Fun fact during processing
            Text(funFact)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 48)
                .padding(.top, 24)
                .opacity(0.7)
            
            Spacer()
        }
        .navigationTitle("Creating Itinerary")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $isNavigating) {
            ItineraryResultScreen(timeline: parsedTimeline.isEmpty ? MockData.timeline : parsedTimeline)
        }
        .onAppear {
            startGlowAnimation()
            runProcessing()
        }
    }
    
    // MARK: - Fun Facts
    
    private var funFact: String {
        let facts = [
            "💡 Tip: We search 100+ venues to find the best matches",
            "✨ Fun fact: The average outing has 4-5 activities",
            "🎯 We consider ratings, distance & vibe for each pick",
            "🗺️ All recommendations are within your city"
        ]
        return facts.randomElement() ?? facts[0]
    }
    
    // MARK: - Glow Animation
    
    private func startGlowAnimation() {
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
            glowOpacity = 0.8
        }
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            iconScale = 1.15
        }
    }
    
    // MARK: - Processing Pipeline
    
    private func runProcessing() {
        Task { @MainActor in
            // Step 1: Reading
            updateStatus("Reading your plan...", emoji: "📖", progress: 10)
            try? await Task.sleep(for: .seconds(0.8))
            
            // Step 2: Understanding
            updateStatus("Understanding your vibe...", emoji: "🧠", progress: 25)
            try? await Task.sleep(for: .seconds(0.7))
            
            // Step 3: Searching
            updateStatus("Searching nearby places...", emoji: "🔍", progress: 40)
            try? await Task.sleep(for: .seconds(0.8))
            
            // Step 4: Matching
            updateStatus("Matching activities...", emoji: "🎯", progress: 55)
            
            // Actually parse the text here
            parsedTimeline = parser.parse(text: planText)
            try? await Task.sleep(for: .seconds(0.7))
            
            // Step 5: Checking ratings
            updateStatus("Checking ratings & reviews...", emoji: "⭐", progress: 70)
            try? await Task.sleep(for: .seconds(0.6))
            
            // Step 6: Building timeline
            updateStatus("Building your timeline...", emoji: "📅", progress: 85)
            try? await Task.sleep(for: .seconds(0.7))
            
            // Step 7: Final touches
            updateStatus("Adding final touches...", emoji: "✨", progress: 100)
            try? await Task.sleep(for: .seconds(0.5))
            
            // Navigate
            isNavigating = true
        }
    }
    
    private func updateStatus(_ text: String, emoji: String, progress: Double) {
        withAnimation {
            statusText = text
            statusEmoji = emoji
            self.progress = progress
        }
        
        // Bounce the icon on each step
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            iconRotation += 15
        }
    }
}
