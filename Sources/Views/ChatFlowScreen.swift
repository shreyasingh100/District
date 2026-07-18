import SwiftUI

struct ChatQuestion {
    let q: String
    let options: [String]
    let multi: Bool
}

struct ChatFlowScreen: View {
    let primaryColor = Color(red: 184/255, green: 164/255, blue: 248/255)
    @State private var step = 0
    @State private var isNavigating = false
    
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
        VStack(alignment: .leading) {
            
            HStack(spacing: 12) {
                Circle()
                    .fill(primaryColor)
                    .frame(width: 40, height: 40)
                    .overlay(Image(systemName: "sparkles").foregroundColor(.white))
                    .shadow(color: Color.black.opacity(0.1), radius: 5)
                
                Text("AI Assistant")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
            }
            .padding(.bottom, 32)
            
            Text(questions[step].q)
                .font(.system(size: 32, weight: .bold))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .padding(.bottom, 40)
                .id(step)
                .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 0.9)), removal: .opacity))
            
            Spacer()
            
            // Options
            ScrollView {
                // Using LazyVGrid for wrapping chips is complex in older iOS, but FlowLayout is possible.
                // For simplicity, we use a VStack of HStacks or just a ScrollView of buttons if not wrapping properly.
                // In iOS 16+, Layout protocol is available. Let's use a simple VStack of buttons for prototype.
                VStack(spacing: 12) {
                    ForEach(questions[step].options, id: \.self) { opt in
                        Button(action: handleNext) {
                            Text(opt)
                                .font(.system(size: 17, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                .foregroundColor(.primary)
                                .cornerRadius(24)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
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
                    .background(LinearGradient(colors: [primaryColor, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                }
                .padding(.top, 16)
            }
            
            HStack(spacing: 8) {
                Spacer()
                ForEach(0..<questions.count, id: \.self) { idx in
                    Circle()
                        .fill(idx == step ? primaryColor : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: step)
                }
                Spacer()
            }
            .padding(.top, 24)
            .padding(.bottom, 16)
            
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isNavigating) {
            ItineraryResultScreen()
        }
    }
    
    func handleNext() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if step < questions.count - 1 {
                step += 1
            } else {
                isNavigating = true
            }
        }
    }
}
