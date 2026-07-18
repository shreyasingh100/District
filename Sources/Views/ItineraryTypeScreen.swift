import SwiftUI
import PhotosUI

struct ItineraryTypeScreen: View {
    let primaryColor = Color(red: 184/255, green: 164/255, blue: 248/255)
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var isNavigatingToUpload = false
    @State private var isLoadingImage = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Option 1
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.tertiarySystemGroupedBackground))
                            .frame(width: 40, height: 40)
                            .overlay(Image(systemName: "doc.text.fill").foregroundColor(primaryColor))
                        Text("Have a Plan?")
                            .font(.system(size: 20, weight: .bold))
                    }
                    
                    Text("Already made an itinerary? Upload it and let AI organize everything.")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                    
                    // Image Picker Button
                    PhotosPicker(
                        selection: $selectedPhotoItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        HStack {
                            if isLoadingImage {
                                ProgressView()
                                    .tint(.white)
                                Text("Loading...")
                            } else {
                                Image(systemName: "tray.and.arrow.up.fill")
                                Text("Upload Image/PDF")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    .disabled(isLoadingImage)
                    
                    NavigationLink(destination: PasteTextScreen()) {
                        Text("Paste Text")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .foregroundColor(.primary)
                            .cornerRadius(16)
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.05), radius: 10)
                
                // Option 2
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(primaryColor.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .overlay(Image(systemName: "message.fill").foregroundColor(primaryColor))
                        Text("Don't Have a Plan?")
                            .font(.system(size: 20, weight: .bold))
                    }
                    
                    Text("Answer a few questions and AI will build your perfect day.")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                    
                    NavigationLink(destination: ChatFlowScreen()) {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [primaryColor, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                }
                .padding()
                .background(
                    LinearGradient(colors: [Color(red: 248/255, green: 245/255, blue: 255/255), .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color(red: 235/255, green: 228/255, blue: 255/255), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 10)
                
            }
            .padding()
        }
        .navigationTitle("Create Itinerary")
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: selectedPhotoItem) { oldValue, newValue in
            guard let newValue else { return }
            isLoadingImage = true
            Task {
                defer { isLoadingImage = false }
                guard let data = try? await newValue.loadTransferable(type: Data.self),
                      let uiImage = UIImage(data: data) else {
                    return
                }
                selectedImage = uiImage
                isNavigatingToUpload = true
            }
        }
        .navigationDestination(isPresented: $isNavigatingToUpload) {
            UploadFlowScreen(uploadedImage: selectedImage)
        }
    }
}
