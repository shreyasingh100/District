import SwiftUI

struct FoodHomeScreen: View {
    @EnvironmentObject var cartManager: CartManager
    @State private var searchText = ""
    
    private let categories: [(String, String, Color)] = [
        ("Dining", "fork.knife.circle.fill", Color(red: 255/255, green: 107/255, blue: 107/255)),
        ("Movies", "film.fill", Color(red: 100/255, green: 149/255, blue: 237/255)),
        ("Events", "music.mic.circle.fill", Color(red: 255/255, green: 193/255, blue: 7/255)),
        ("Stores", "bag.fill", Color(red: 76/255, green: 175/255, blue: 80/255)),
        ("Activities", "figure.run.circle.fill", Color(red: 0/255, green: 188/255, blue: 212/255)),
        ("Play", "gamecontroller.fill", Color(red: 233/255, green: 30/255, blue: 99/255))
    ]
    
    var body: some View {
        NavigationStack {
                ZStack(alignment: .top) {
                    Theme.heroGradient
                        .frame(height: 280)
                        .ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Hero gradient background
                        
                            
                            VStack(spacing: Theme.paddingM) {
                                // Location header
                                locationHeader
                                    .padding(.top, 8)
                                
                                // Search bar
                                searchBar
                                
                                // District branding
                                districtBranding
                            }
                            .padding(.horizontal, Theme.paddingM)
                        }
                        
                        VStack(spacing: Theme.paddingL) {
                            // Category grid
                            categoryGrid
                                .padding(.horizontal, Theme.paddingM)
                            
                            // Divider
                            Rectangle()
                                .fill(Theme.elevatedSurface)
                                .frame(height: 8)
                            
                            // In the Spotlight section
                            spotlightSection
                            
                            // Trending Restros
                            trendingSection
                                .padding(.bottom, cartManager.isEmpty ? 100 : 160)
                        }
                        .padding(.top, Theme.paddingM)
                    }
                }
                .background(Theme.background)
                
                // Cart banner
                if !cartManager.isEmpty {
                    cartBanner
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 90)
                
            }
            //.navigationBarHidden(true)
        }
    }
    
    // MARK: - Location Header
    
    private var locationHeader: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "location.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Theme.primary)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text("Chhatarpur Farms")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                    
                    Text("DLF Farms, New Delhi")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textSecondary)
                }
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {}) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 18))
                        .foregroundColor(Theme.textPrimary)
                }
                
                Button(action: {}) {
                    Circle()
                        .fill(Theme.elevatedSurface)
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 16))
                                .foregroundColor(Theme.textSecondary)
                        )
                }
            }
        }
    }
    
    // MARK: - Search Bar
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundColor(Theme.textMuted)
            
            Text("Search for restaurants, dishes...")
                .font(.system(size: 15))
                .foregroundColor(Theme.textMuted)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Theme.elevatedSurface)
        .cornerRadius(Theme.cornerM)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerM)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
    
    // MARK: - District Branding
    
    private var districtBranding: some View {
        VStack(spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("District")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Theme.primary, Color.purple.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("Explore the City")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                }
                Spacer()
            }
        }
        .padding(.top, 4)
    }
    
    // MARK: - Category Grid
    
    private var categoryGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 12) {
            ForEach(categories, id: \.0) { category in
                categoryCard(name: category.0, icon: category.1, color: category.2)
            }
        }
    }
    
    private func categoryCard(name: String, icon: String, color: Color) -> some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 52, height: 52)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            
            Text(name)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerM)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerM)
                .stroke(Color.white.opacity(0.04), lineWidth: 1)
        )
    }
    
    // MARK: - In the Spotlight
    
    private var spotlightSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("In the spotlight")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .padding(.horizontal, Theme.paddingM)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    spotlightCard(
                        title: "50% OFF",
                        subtitle: "on first 3 orders",
                        icon: "tag.fill",
                        gradient: [Color(red: 0/255, green: 100/255, blue: 80/255), Color(red: 0/255, green: 60/255, blue: 50/255)]
                    )
                    
                    spotlightCard(
                        title: "Free Delivery",
                        subtitle: "on orders above ₹199",
                        icon: "bicycle",
                        gradient: [Color(red: 100/255, green: 40/255, blue: 120/255), Color(red: 60/255, green: 20/255, blue: 80/255)]
                    )
                    
                    spotlightCard(
                        title: "Flat ₹125 OFF",
                        subtitle: "use code DISTRICT125",
                        icon: "percent",
                        gradient: [Color(red: 160/255, green: 60/255, blue: 30/255), Color(red: 100/255, green: 30/255, blue: 20/255)]
                    )
                }
                .padding(.horizontal, Theme.paddingM)
            }
        }
    }
    
    private func spotlightCard(title: String, subtitle: String, icon: String, gradient: [Color]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white.opacity(0.9))
                Spacer()
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(20)
        .frame(width: 200, height: 160)
        .background(
            LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(Theme.cornerL)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerL)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
    
    // MARK: - Trending Restros
    
    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Trending Restros Near You 🔥")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("\(MockData.restaurants.count) restaurants around you")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textSecondary)
                }
                Spacer()
                
                Button("See All") {}
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.primary)
            }
            .padding(.horizontal, Theme.paddingM)
            
            VStack(spacing: 16) {
                ForEach(MockData.restaurants) { restaurant in
                    NavigationLink(destination: RestaurantDetailScreen(restaurant: restaurant)) {
                        restaurantRow(restaurant)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, Theme.paddingM)
        }
    }
    
    private func restaurantRow(_ restaurant: Restaurant) -> some View {
        HStack(spacing: 14) {
            // Restaurant icon
            ZStack {
                RoundedRectangle(cornerRadius: Theme.cornerS)
                    .fill(Theme.elevatedSurface)
                    .frame(width: 80, height: 80)
                
                Image(systemName: restaurant.imageSystemName)
                    .font(.system(size: 28))
                    .foregroundColor(Theme.primary.opacity(0.8))
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(restaurant.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    if restaurant.promoted {
                        Text("AD")
                            .font(.system(size: 9, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Theme.textMuted.opacity(0.3))
                            .foregroundColor(Theme.textSecondary)
                            .cornerRadius(4)
                    }
                }
                
                Text(restaurant.cuisine)
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textSecondary)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.green)
                        Text(restaurant.rating)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                    
                    Text("•")
                        .foregroundColor(Theme.textMuted)
                    
                    Text(restaurant.deliveryTime)
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textSecondary)
                    
                    Text("•")
                        .foregroundColor(Theme.textMuted)
                    
                    Text(restaurant.distance)
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textSecondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(Theme.textMuted)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerM)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerM)
                .stroke(Color.white.opacity(0.04), lineWidth: 1)
        )
    }
    
    // MARK: - Cart Banner
    
    private var cartBanner: some View {
        NavigationLink(destination: CartScreen()) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(cartManager.itemCount) item\(cartManager.itemCount > 1 ? "s" : "") added")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    
                    if let name = cartManager.restaurantName {
                        Text("From \(name)")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                Spacer()
                
                HStack(spacing: 6) {
                    Text("₹\(Int(cartManager.totalPrice))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("View Cart")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    
                    Image(systemName: "bag.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: [Color.green.opacity(0.9), Color(red: 0/255, green: 130/255, blue: 70/255)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(Theme.cornerM)
            .shadow(color: Color.green.opacity(0.3), radius: 10, y: 5)
            .padding(.horizontal, Theme.paddingM)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
