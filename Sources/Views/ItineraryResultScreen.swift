import SwiftUI
import MapKit

struct ItineraryResultScreen: View {

    let primaryColor = Color(red: 184/255, green: 164/255, blue: 248/255)
    var timeline: [TimelineBlock] = MockData.timeline

    @EnvironmentObject var itineraryStore: ItineraryStore
    @Environment(\.dismiss) var dismiss
    let timeline = MockData.timeline
    @State private var isFinalized = false

    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // Search & Filters
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "magnifyingglass").foregroundColor(Theme.textMuted)
                            Text("Search activities, restaurants...").foregroundColor(Theme.textMuted)
                            Spacer()
                            Image(systemName: "line.3.horizontal.decrease.circle").foregroundColor(Theme.primary)
                        }
                        .padding()
                        .background(Theme.cardBackground)
                        .cornerRadius(Theme.cornerM)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(["Open Now", "Distance", "Rating 4.5+", "Budget", "Trending"], id: \.self) { filter in
                                    Text(filter)
                                        .font(.system(size: 14, weight: .medium))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Theme.cardBackground)
                                        .foregroundColor(Theme.textSecondary)
                                        .cornerRadius(20)
                                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.08), lineWidth: 1))
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Theme.surfaceBackground)
                    
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
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Theme.primaryGradient)
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
                                        .fill(Theme.cardBackground)
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            Circle().stroke(Theme.primary, lineWidth: 2)
                                        )
                                        .overlay(Text(block.icon))
                                    
                                    if index != timeline.count - 1 {
                                        Rectangle()
                                            .fill(Theme.primary.opacity(0.3))
                                            .frame(width: 2)
                                            .padding(.top, 4)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack(alignment: .bottom) {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(block.time)
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(Theme.primary)
                                            Text(block.title)
                                                .font(.system(size: 22, weight: .bold))
                                                .foregroundColor(Theme.textPrimary)
                                        }
                                        Spacer()
                                        Button("View All >") { }
                                            .font(.system(size: 14))
                                            .foregroundColor(Theme.textSecondary)
                                    }
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(block.items) { item in
                                                VenueCard(item: item)
                                            }
                                        }
                                        .padding(.bottom, 16)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, 100)
                }
            }
            .background(Theme.background.edgesIgnoringSafeArea(.all))
            
            // Finalize Button
            if !isFinalized {
                finalizeButton
            }
        }
        .navigationTitle("Your Itinerary")
        .navigationBarTitleDisplayMode(.inline)

        .navigationBarBackButtonHidden(true)

        .toolbarColorScheme(.dark, for: .navigationBar)

        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    NavigationUtil.popToRootView()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(primaryColor)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Image(systemName: "square.and.arrow.up").foregroundColor(Theme.primary)
                    Image(systemName: "heart").foregroundColor(Theme.primary)
                }
            }
        }
    }
    
    // MARK: - Finalize Button
    
    private var finalizeButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isFinalized = true
                itineraryStore.finalize(timeline: timeline, title: "Today's Plan")
            }
            // Navigate back after short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                dismiss()
            }
        }) {
            HStack(spacing: 10) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 18))
                Text("Finalize Itinerary")
                    .font(.system(size: 17, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.primaryGradient)
            .cornerRadius(Theme.cornerM)
            .shadow(color: Theme.primary.opacity(0.4), radius: 12, y: 5)
        }
        .padding(.horizontal, Theme.paddingM)
        .padding(.bottom, 12)
        .background(
            LinearGradient(
                colors: [Theme.background.opacity(0), Theme.background],
                startPoint: .top,
                endPoint: .center
            )
        )
    }
}

// MARK: - Navigation Helper
struct NavigationUtil {
    static func popToRootView() {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .filter({ $0.isKeyWindow }).first
        
        let rootViewController = keyWindow?.rootViewController
        if let navigationController = findNavigationController(viewController: rootViewController) {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else { return nil }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        return nil
    }
}

struct VenueCard: View {
    let item: Activity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image area
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Theme.elevatedSurface)
                    .frame(height: 140)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(Theme.textMuted.opacity(0.3))
                    )
                
                Circle()
                    .fill(Theme.cardBackground.opacity(0.9))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "heart")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textSecondary)
                    )
                    .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text(item.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                        .lineLimit(1)
                    Spacer()
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill").foregroundColor(.yellow).font(.system(size: 12))
                        Text(item.rating)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
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
                .foregroundColor(Theme.textSecondary)
                
                HStack {
                    ForEach(item.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 11))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Theme.elevatedSurface)
                            .foregroundColor(Theme.textSecondary)
                            .cornerRadius(8)
                    }
                }
                .padding(.top, 4)
                
                Button(action: {}) {
                    Text(item.price != nil ? "Book Now" : "Reserve Table")
                        .font(.system(size: 15, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.primary)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 8)
            }
            .padding(16)
        }
        .frame(width: 260)
        .background(Theme.cardBackground)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
    }
}
