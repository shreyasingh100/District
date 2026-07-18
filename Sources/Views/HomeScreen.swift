import SwiftUI

struct HomeScreen: View {
    let primaryColor = Color(red: 184/255, green: 164/255, blue: 248/255)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // District Highlight Card
                    HStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(primaryColor.opacity(0.2))
                            .frame(width: 48, height: 48)
                            .overlay(Image(systemName: "map.fill").foregroundColor(primaryColor))
                        
                        VStack(alignment: .leading) {
                            Text("Explore the City")
                                .font(.system(size: 18, weight: .bold))
                            Text("Find hidden gems nearby.")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, y: 5)
                    
                    // AI Itinerary Planner Card
                    NavigationLink(destination: ItineraryTypeScreen()) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("✨ NEW")
                                    .font(.system(size: 12, weight: .bold))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(primaryColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                Spacer()
                                
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 40, height: 40)
                                    .overlay(Image(systemName: "sparkles").foregroundColor(primaryColor))
                                    .shadow(color: Color.black.opacity(0.1), radius: 5)
                            }
                            
                            Text("AI Itinerary Planner")
                                .font(.system(size: 26, weight: .bold, design: .default))
                                .foregroundStyle(LinearGradient(colors: [primaryColor, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            
                            Text("Plan your perfect day effortlessly.")
                                .font(.system(size: 15))
                                .foregroundColor(.secondary)
                        }
                        .padding(24)
                        .background(
                            LinearGradient(colors: [Color(red: 240/255, green: 235/255, blue: 255/255), .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .cornerRadius(24)
                        .shadow(color: primaryColor.opacity(0.2), radius: 15, y: 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    VStack(alignment: .leading) {
                        Text("Trending near you")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.top, 8)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 200)
                            .overlay(
                                VStack {
                                    Spacer()
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("The Vintage Cafe")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            Text("Downtown • 2km away")
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .background(.ultraThinMaterial)
                                }
                            )
                            .cornerRadius(16)
                    }
                }
                .padding()
            }
            .navigationTitle("District")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "bell")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}
