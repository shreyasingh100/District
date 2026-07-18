import SwiftUI

struct UploadFlowScreen: View {

    let primaryColor = Color(red: 184/255, green: 164/255, blue: 248/255)
    
    /// The image passed from the picker. If nil, runs with mock animation.
    var uploadedImage: UIImage? = nil
    

    @EnvironmentObject var itineraryStore: ItineraryStore
    @State private var scanPosition: CGFloat = -140
    @State private var statusText: String = "Reading your itinerary..."
    @State private var progress: Double = 0.0
    @State private var isNavigating = false
    @State private var analysisResult: [TimelineBlock] = []
    @State private var showError = false
    @State private var errorMessage = ""
    
    private let analysisService = ImageAnalysisService()
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            

            // Scanner Visual
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(UIColor.secondarySystemGroupedBackground))
                    .frame(width: 200, height: 280)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(primaryColor.opacity(0.5), lineWidth: 2)
                    )
                
                // Show uploaded image or mock document
                if let uploadedImage {
                    Image(uiImage: uploadedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
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
                }
            VStack {
                Spacer()
                
                // Apple Intelligence Style Glowing Scanner
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Theme.cardBackground)
                        .frame(width: 200, height: 280)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Theme.primary.opacity(0.5), lineWidth: 2)
                        )
                    
                    // Mock Document
                    VStack(alignment: .leading, spacing: 16) {
                        RoundedRectangle(cornerRadius: 6).fill(Theme.elevatedSurface).frame(width: 120, height: 12)
                        RoundedRectangle(cornerRadius: 4).fill(Theme.elevatedSurface).frame(width: 160, height: 8)
                        RoundedRectangle(cornerRadius: 4).fill(Theme.elevatedSurface).frame(width: 140, height: 8)
                        Spacer().frame(height: 10)
                        RoundedRectangle(cornerRadius: 6).fill(Theme.elevatedSurface).frame(width: 80, height: 12)
                        RoundedRectangle(cornerRadius: 4).fill(Theme.elevatedSurface).frame(width: 150, height: 8)
                        RoundedRectangle(cornerRadius: 4).fill(Theme.elevatedSurface).frame(width: 130, height: 8)
                    }
                    .padding(24)
                    
                    // Scan Line
                    Rectangle()
                        .fill(
                            LinearGradient(colors: [.clear, Theme.primary, .clear], startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: 200, height: 4)
                        .shadow(color: Theme.primary, radius: 10, y: 0)
                        .offset(y: scanPosition)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: Theme.primary.opacity(0.2), radius: 20)
                .padding(.bottom, 40)
                
                Text(statusText)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .animation(.easeInOut, value: statusText)
                
                Text("Our AI is organizing your schedule for a seamless experience.")
                    .font(.system(size: 15))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)
                
                // Progress bar
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Theme.elevatedSurface)
                        .frame(width: 200, height: 6)
                    
                    Capsule()
                        .fill(Theme.primaryGradient)
                        .frame(width: CGFloat(progress / 100.0 * 200), height: 6)
                        .animation(.linear(duration: 1.5), value: progress)
                }
                
                Spacer()
            }
        }
        .navigationTitle("Scanning")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(isPresented: $isNavigating) {

            ItineraryResultScreen(timeline: analysisResult.isEmpty ? MockData.timeline : analysisResult)
        }
        .alert("Analysis Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)

            ItineraryResultScreen()
                .environmentObject(itineraryStore)
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                scanPosition = 140
            }
            
            if let image = uploadedImage {
                // Real analysis pipeline
                runAnalysis(image: image)
            } else {
                // Mock animation for "Paste Text" flow
                runMockAnimation()
            }
        }
    }
    
    // MARK: - Real Analysis
    
    private func runAnalysis(image: UIImage) {
        Task {
            do {
                // Step 1: Reading
                statusText = "Reading your itinerary..."
                progress = 20
                try await Task.sleep(for: .milliseconds(600))
                
                // Step 2: Analyzing with Vision ML
                statusText = "Analyzing image content..."
                progress = 40
                
                let result = try await analysisService.analyze(image: image)
                
                // Step 3: Building
                statusText = "Finding nearby places..."
                progress = 70
                try await Task.sleep(for: .milliseconds(500))
                
                // Step 4: Timeline
                statusText = "Building perfect timeline..."
                progress = 100
                analysisResult = result
                try await Task.sleep(for: .milliseconds(500))
                
                isNavigating = true
                
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
    
    // MARK: - Mock Animation (fallback)
    
    private func runMockAnimation() {
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
