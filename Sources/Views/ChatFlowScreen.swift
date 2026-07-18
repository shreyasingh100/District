import SwiftUI

struct ChatQuestion {
    let q: String
    let options: [String]
    let multi: Bool
}

struct ChatFlowScreen: View {
    @EnvironmentObject var itineraryStore: ItineraryStore
    @State private var step = 0
    @State private var isNavigating = false
    @State private var selectedOptions: Set<String> = []
    
    let questions = [
        ChatQuestion(q: "Want to have food?", options: ["Yes", "No"], multi: false),
        ChatQuestion(q: "What kind of food?", options: ["Breakfast", "Lunch", "Dinner", "Cafe", "Street Food"], multi: true),
        ChatQuestion(q: "Want activities?", options: ["Paintball", "Bowling", "Movies", "Arcade", "Shopping", "Sports"], multi: true),
        ChatQuestion(q: "Who are you going with?", options: ["Solo", "Friends", "Family", "Partner"], multi: false),
        ChatQuestion(q: "Budget per person?", options: ["₹500", "₹1000", "₹2000", "₹5000+"], multi: false),
        ChatQuestion(q: "Travel Radius?", options: ["2 km", "5 km", "10 km", "Anywhere"], multi: false),
        ChatQuestion(q: "Preferred Time?", options: ["Morning", "Afternoon", "Evening", "Night"], multi: true)
    ]
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Theme.primary)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "sparkles")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    }
                    .shadow(color: Theme.primary.opacity(0.3), radius: 8)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("AI Assistant")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Theme.textPrimary)
                        Text("Surprise Me")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                    }
                    Spacer()
                    
                    // Step indicator
                    Text("\(step + 1) / \(questions.count)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Theme.textMuted)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Theme.elevatedSurface)
                        .cornerRadius(12)
                }
                .padding(.bottom, 32)
                
                Text(questions[step].q)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .padding(.bottom, 40)
                    .id(step)
                    .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 0.9)), removal: .opacity))
                
                Spacer()
                
                // Options
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(questions[step].options, id: \.self) { opt in
                            Button(action: {
                                if questions[step].multi {
                                    if selectedOptions.contains(opt) {
                                        selectedOptions.remove(opt)
                                    } else {
                                        selectedOptions.insert(opt)
                                    }
                                } else {
                                    handleNext()
                                }
                            }) {
                                HStack {
                                    Text(opt)
                                        .font(.system(size: 17, weight: .medium))
                                    
                                    Spacer()
                                    
                                    if questions[step].multi {
                                        Image(systemName: selectedOptions.contains(opt) ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(selectedOptions.contains(opt) ? Theme.primary : Theme.textMuted)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background(
                                    selectedOptions.contains(opt) 
                                        ? Theme.primary.opacity(0.12) 
                                        : Theme.cardBackground
                                )
                                .foregroundColor(
                                    selectedOptions.contains(opt) 
                                        ? Theme.primary 
                                        : Theme.textPrimary
                                )
                                .cornerRadius(Theme.cornerM)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.cornerM)
                                        .stroke(
                                            selectedOptions.contains(opt) 
                                                ? Theme.primary.opacity(0.4)
                                                : Color.white.opacity(0.06),
                                            lineWidth: 1
                                        )
                                )
                            }
                        }
                    }
                }
                
                if questions[step].multi {
                    Button(action: handleNext) {
                        HStack {
                            Text("Continue")
                            Image(systemName: "arrow.right")
                        }
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Theme.primaryGradient)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(color: Theme.primary.opacity(0.3), radius: 10, y: 5)
                    }
                    .padding(.top, 16)
                }
                
                // Progress dots
                HStack(spacing: 8) {
                    Spacer()
                    ForEach(0..<questions.count, id: \.self) { idx in
                        Capsule()
                            .fill(idx == step ? Theme.primary : Theme.elevatedSurface)
                            .frame(width: idx == step ? 24 : 8, height: 8)
                            .animation(.easeInOut, value: step)
                    }
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.bottom, 16)
                
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(isPresented: $isNavigating) {
            ItineraryResultScreen()
                .environmentObject(itineraryStore)
        }
    }
    
    func handleNext() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            selectedOptions.removeAll()
            if step < questions.count - 1 {
                step += 1
            } else {
                isNavigating = true
            }
        }
    }
}
