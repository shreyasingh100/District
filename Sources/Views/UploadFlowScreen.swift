import SwiftUI

struct UploadFlowScreen: View {
    let primaryColor = Color(red: 184/255, green: 164/255, blue: 248/255)
    @State private var scanPosition: CGFloat = -140
    @State private var statusText: String = "Reading your itinerary..."
    @State private var progress: Double = 0.0
    @State private var isNavigating = false
    
    var body: some View {
        VStack {
            Spacer()
            
            // Apple Intelligence Style Glowing Scanner
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(UIColor.secondarySystemGroupedBackground))
                    .frame(width: 200, height: 280)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(primaryColor.opacity(0.5), lineWidth: 2)
                    )
                
                // Mock Document
                VStack(alignment: .leading, spacing: 16) {
                    RoundedRectangle(cornerRadius: 6).fill(Color.gray.opacity(0.3)).frame(width: 120, height: 12)
                    RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.3)).frame(width: 160, height: 8)
                    RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.3)).frame(width: 140, height: 8)
                    Spacer().frame(height: 10)
                    RoundedRectangle(cornerRadius: 6).fill(Color.gray.opacity(0.3)).frame(width: 80, height: 12)
                    RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.3)).frame(width: 150, height: 8)
                    RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.3)).frame(width: 130, height: 8)
                }
                .padding(24)
                
                // Scan Line
                Rectangle()
                    .fill(
                        LinearGradient(colors: [.clear, primaryColor, .clear], startPoint: .leading, endPoint: .trailing)
                    )
                    .frame(width: 200, height: 4)
                    .shadow(color: primaryColor, radius: 10, y: 0)
                    .offset(y: scanPosition)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: primaryColor.opacity(0.2), radius: 20)
            .padding(.bottom, 40)
            
            Text(statusText)
                .font(.system(size: 24, weight: .bold))
                .multilineTextAlignment(.center)
                .animation(.easeInOut, value: statusText)
            
            Text("Our AI is organizing your schedule for a seamless experience.")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            
            ProgressView(value: progress, total: 100)
                .progressViewStyle(LinearProgressViewStyle(tint: primaryColor))
                .frame(width: 200)
                .animation(.linear(duration: 1.5), value: progress)
            
            Spacer()
        }
        .navigationTitle("Scanning")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isNavigating) {
            ItineraryResultScreen()
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                scanPosition = 140
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                statusText = "Parsing activities..."
                progress = 33
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                statusText = "Finding nearby places..."
                progress = 66
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                statusText = "Building perfect timeline..."
                progress = 100
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                isNavigating = true
            }
        }
    }
}
