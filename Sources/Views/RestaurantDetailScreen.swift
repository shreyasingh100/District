import SwiftUI

struct RestaurantDetailScreen: View {
    let restaurant: Restaurant
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.dismiss) var dismiss
    @State private var addedItems: Set<UUID> = []
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Restaurant Header
                    restaurantHeader
                    
                    // Quick Info Bar
                    quickInfoBar
                    
                    // Menu
                    menuSection
                        .padding(.bottom, cartManager.isEmpty ? 20 : 100)
                }
            }
            .background(Theme.background)
            
            // Cart banner
            if !cartManager.isEmpty {
                cartFloatingBar
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    // MARK: - Header
    
    private var restaurantHeader: some View {
        ZStack(alignment: .bottomLeading) {
            // Background
            LinearGradient(
                colors: [Theme.primary.opacity(0.3), Theme.background],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 200)
            .overlay(
                Image(systemName: restaurant.imageSystemName)
                    .font(.system(size: 60))
                    .foregroundColor(Theme.primary.opacity(0.2))
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(restaurant.name)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                
                Text(restaurant.cuisine)
                    .font(.system(size: 15))
                    .foregroundColor(Theme.textSecondary)
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.green)
                        Text(restaurant.rating)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.15))
                    .cornerRadius(8)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                        Text(restaurant.deliveryTime)
                    }
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textSecondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .font(.system(size: 12))
                        Text(restaurant.distance)
                    }
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textSecondary)
                }
            }
            .padding(Theme.paddingM)
        }
    }
    
    // MARK: - Quick Info Bar
    
    private var quickInfoBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                infoPill(icon: "bicycle", text: "Free Delivery")
                infoPill(icon: "percent", text: "50% OFF up to ₹100")
                infoPill(icon: "clock.badge.checkmark", text: "On-time guaranteed")
            }
            .padding(.horizontal, Theme.paddingM)
        }
        .padding(.vertical, 12)
        .background(Theme.surfaceBackground)
    }
    
    private func infoPill(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Theme.primary)
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Theme.textSecondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Theme.elevatedSurface)
        .cornerRadius(20)
    }
    
    // MARK: - Menu Section
    
    private var menuSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Menu")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14))
                    Text("Search menu")
                        .font(.system(size: 14))
                }
                .foregroundColor(Theme.textMuted)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Theme.elevatedSurface)
                .cornerRadius(20)
            }
            
            // Bestsellers
            let bestsellers = restaurant.menuItems.filter { $0.isBestseller }
            if !bestsellers.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("Bestsellers")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                    
                    ForEach(bestsellers) { item in
                        menuItemRow(item)
                    }
                }
            }
            
            // Full Menu
            VStack(alignment: .leading, spacing: 12) {
                Text("Full Menu")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                    .padding(.top, 8)
                
                ForEach(restaurant.menuItems) { item in
                    menuItemRow(item)
                }
            }
        }
        .padding(Theme.paddingM)
    }
    
    private func menuItemRow(_ item: MenuItem) -> some View {
        HStack(alignment: .top, spacing: 14) {
            // Veg/Non-veg indicator
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(item.isVeg ? Color.green : Color.red, lineWidth: 1.5)
                        .frame(width: 16, height: 16)
                    
                    Circle()
                        .fill(item.isVeg ? Color.green : Color.red)
                        .frame(width: 7, height: 7)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(item.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Theme.textPrimary)
                        
                        if item.isBestseller {
                            Text("⭐")
                                .font(.system(size: 12))
                        }
                    }
                    
                    Text("₹\(Int(item.price))")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text(item.description)
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textMuted)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            // Add button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    cartManager.addItem(name: item.name, price: item.price, restaurantName: restaurant.name)
                    addedItems.insert(item.id)
                }
            }) {
                if addedItems.contains(item.id) {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                        Text("Added")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.green)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.green.opacity(0.15))
                    .cornerRadius(12)
                } else {
                    Text("ADD")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Theme.primary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Theme.primary.opacity(0.12))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.primary.opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerS)
    }
    
    // MARK: - Cart Floating Bar
    
    private var cartFloatingBar: some View {
        NavigationLink(destination: CartScreen()) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(cartManager.itemCount) item\(cartManager.itemCount > 1 ? "s" : "")")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    Text("₹\(Int(cartManager.totalPrice)) plus taxes")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                HStack(spacing: 6) {
                    Text("View Cart")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    Image(systemName: "bag.fill")
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
            .padding(.bottom, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
