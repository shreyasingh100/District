import SwiftUI

struct PasteTextScreen: View {
    let primaryColor = Color(red: 184/255, green: 164/255, blue: 248/255)
    
    @State private var planText: String = ""
    @State private var isNavigating = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Header
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Circle()
                        .fill(primaryColor)
                        .frame(width: 36, height: 36)
                        .overlay(Image(systemName: "sparkles").font(.system(size: 16)).foregroundColor(.white))
                    Text("Describe your plan")
                        .font(.system(size: 18, weight: .semibold))
                    Spacer()
                }
                
                Text("Type what you want to do — breakfast, movies, paintball, arcade, sightseeing, dinner... We'll build the perfect itinerary!")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 20)
            
            // Text Editor
            ZStack(alignment: .topLeading) {
                TextEditor(text: $planText)
                    .focused($isFocused)
                    .font(.system(size: 16))
                    .padding(16)
                    .scrollContentBackground(.hidden)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isFocused ? primaryColor : Color.gray.opacity(0.2), lineWidth: isFocused ? 2 : 1)
                    )
                
                if planText.isEmpty {
                    Text("e.g. I want to go bowling in the morning, then grab lunch at a good restaurant, watch a movie in the afternoon, and end with dinner at a rooftop bar...")
                        .font(.system(size: 16))
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .allowsHitTesting(false)
                }
            }
            .frame(minHeight: 200)
            .padding(.horizontal, 20)
            
            // Quick Suggestions
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    quickSuggestion("🎳 Bowling")
                    quickSuggestion("🎬 Movie")
                    quickSuggestion("🎯 Paintball")
                    quickSuggestion("🕹️ Arcade")
                    quickSuggestion("🏛️ Sightseeing")
                    quickSuggestion("🍽️ Dinner")
                    quickSuggestion("🧖 Spa")
                    quickSuggestion("🛍️ Shopping")
                    quickSuggestion("🍷 Nightlife")
                    quickSuggestion("☕ Cafe")
                    quickSuggestion("🍜 Street Food")
                    quickSuggestion("⚽ Sports")
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 16)
            
            Spacer()
            
            // Generate Button
            Button(action: {
                isFocused = false
                isNavigating = true
            }) {
                let isEmpty = planText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                HStack(spacing: 10) {
                    Image(systemName: "wand.and.stars")
                    Text("Generate Itinerary")
                }
                .font(.system(size: 17, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    Group {
                        if isEmpty {
                            LinearGradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                        } else {
                            LinearGradient(colors: [primaryColor, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                        }
                    }
                )
                .foregroundColor(.white)
                .cornerRadius(20)
            }
            .disabled(planText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .navigationTitle("Your Plan")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { isFocused = true }
        .navigationDestination(isPresented: $isNavigating) {
            TextProcessingScreen(planText: planText)
        }
    }
    
    // MARK: - Quick Suggestion Chip
    
    @ViewBuilder
    private func quickSuggestion(_ text: String) -> some View {
        Button {
            if !planText.isEmpty && !planText.hasSuffix(" ") && !planText.hasSuffix("\n") {
                planText += ", "
            }
            // Remove emoji prefix for the text
            let cleaned = text.components(separatedBy: " ").dropFirst().joined(separator: " ")
            planText += cleaned.lowercased()
        } label: {
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color(UIColor.tertiarySystemGroupedBackground))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
