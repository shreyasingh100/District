import SwiftUI
import MapKit

struct ItineraryResultScreen: View {
    let primaryColor = Color(red: 184/255, green: 164/255, blue: 248/255)
    let timeline = MockData.timeline
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // Search & Filters
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                        Text("Search activities, restaurants...").foregroundColor(.secondary)
                        Spacer()
                        Image(systemName: "line.3.horizontal.decrease.circle").foregroundColor(primaryColor)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 5)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(["Open Now", "Distance", "Rating 4.5+", "Budget", "Trending"], id: \.self) { filter in
                                Text(filter)
                                    .font(.system(size: 14, weight: .medium))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                            }
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                
                // Smart Features Banner
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Time").font(.system(size: 12)).opacity(0.8)
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                            Text("10 Hours").bold()
                        }
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Est. Travel").font(.system(size: 12)).opacity(0.8)
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                            Text("14 km").bold()
                        }
                    }
                    Spacer()
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Image(systemName: "map.fill")
                            Text("Map View")
                        }
                        .font(.system(size: 14, weight: .bold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .foregroundColor(primaryColor)
                        .cornerRadius(12)
                    }
                }
                .padding()
                .background(LinearGradient(colors: [primaryColor, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // Timeline
                VStack(spacing: 32) {
                    ForEach(Array(timeline.enumerated()), id: \.offset) { index, block in
                        HStack(alignment: .top, spacing: 16) {
                            
                            // Timeline dot & line
                            VStack(spacing: 0) {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Circle().stroke(primaryColor, lineWidth: 2)
                                    )
                                    .overlay(Text(block.icon))
                                
                                if index != timeline.count - 1 {
                                    Rectangle()
                                        .fill(primaryColor.opacity(0.3))
                                        .frame(width: 2)
                                        .padding(.top, 4)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(alignment: .bottom) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(block.time)
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(primaryColor)
                                        Text(block.title)
                                            .font(.system(size: 22, weight: .bold))
                                    }
                                    Spacer()
                                    Button("View All >") { }
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary)
                                }
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(block.items) { item in
                                            VenueCard(item: item)
                                        }
                                    }
                                    .padding(.bottom, 16) // For shadow
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color(UIColor.secondarySystemGroupedBackground).edgesIgnoringSafeArea(.all))
        .navigationTitle("Your Itinerary")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Image(systemName: "square.and.arrow.up").foregroundColor(primaryColor)
                    Image(systemName: "heart").foregroundColor(primaryColor)
                }
            }
        }
    }
}

struct VenueCard: View {
    let item: Activity
    let primaryColor = Color(red: 184/255, green: 164/255, blue: 248/255)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image area (Mocked with gray for now since we don't have assets)
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 140)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.gray.opacity(0.5))
                    )
                
                Circle()
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 32, height: 32)
                    .overlay(Image(systemName: "heart").font(.system(size: 14)))
                    .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text(item.name)
                        .font(.system(size: 18, weight: .bold))
                        .lineLimit(1)
                    Spacer()
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill").foregroundColor(.yellow).font(.system(size: 12))
                        Text(item.rating).font(.system(size: 14, weight: .bold))
                    }
                }
                
                HStack {
                    Image(systemName: "mappin.and.ellipse").font(.system(size: 12))
                    Text(item.distance)
                    if let price = item.price {
                        Text("• \(price)")
                    }
                }
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                
                HStack {
                    ForEach(item.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 11))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(UIColor.tertiarySystemGroupedBackground))
                            .foregroundColor(.secondary)
                            .cornerRadius(8)
                    }
                }
                .padding(.top, 4)
                
                Button(action: {}) {
                    Text(item.price != nil ? "Book Now" : "Reserve Table")
                        .font(.system(size: 15, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 8)
            }
            .padding(16)
        }
        .frame(width: 260)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 10, y: 5)
    }
}
