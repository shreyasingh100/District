import SwiftUI

struct CartScreen: View {
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.dismiss) var dismiss
    @State private var orderPlaced = false
    
    private let deliveryFee: Double = 29
    private let taxRate: Double = 0.05
    
    private var subtotal: Double { cartManager.totalPrice }
    private var taxes: Double { subtotal * taxRate }
    private var grandTotal: Double { subtotal + deliveryFee + taxes }
    
    var body: some View {
        ZStack {
            if orderPlaced {
                orderSuccessView
            } else {
                cartContentView
            }
        }
        .background(Theme.background)
        .navigationTitle("Cart")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    // MARK: - Cart Content
    
    private var cartContentView: some View {
        VStack(spacing: 0) {
            if cartManager.isEmpty {
                emptyCartView
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Restaurant info
                        if let name = cartManager.restaurantName {
                            HStack(spacing: 12) {
                                Image(systemName: "building.2.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(Theme.primary)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(name)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Theme.textPrimary)
                                    Text("Delivering to Chhatarpur Farms")
                                        .font(.system(size: 12))
                                        .foregroundColor(Theme.textSecondary)
                                }
                                
                                Spacer()
                            }
                            .padding(14)
                            .background(Theme.cardBackground)
                            .cornerRadius(Theme.cornerS)
                        }
                        
                        // Cart Items
                        VStack(spacing: 0) {
                            ForEach(cartManager.items) { item in
                                cartItemRow(item)
                                
                                if item.id != cartManager.items.last?.id {
                                    Divider()
                                        .background(Theme.elevatedSurface)
                                }
                            }
                        }
                        .background(Theme.cardBackground)
                        .cornerRadius(Theme.cornerS)
                        
                        // Add more
                        Button(action: { dismiss() }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Theme.primary)
                                Text("Add more items")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Theme.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.textMuted)
                            }
                            .padding(14)
                            .background(Theme.cardBackground)
                            .cornerRadius(Theme.cornerS)
                        }
                        
                        // Bill Details
                        billSection
                        
                        // Delivery info
                        deliveryInfoSection
                    }
                    .padding(Theme.paddingM)
                    .padding(.bottom, 100)
                }
                
                // Place Order Button
                placeOrderButton
            }
        }
    }
    
    // MARK: - Cart Item Row
    
    private func cartItemRow(_ item: CartItem) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.green, lineWidth: 1.5)
                    .frame(width: 16, height: 16)
                Circle()
                    .fill(Color.green)
                    .frame(width: 7, height: 7)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                
                Text("₹\(Int(item.price))")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            // Quantity controls
            HStack(spacing: 0) {
                Button(action: {
                    withAnimation { cartManager.decrementQuantity(item) }
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Theme.primary)
                        .frame(width: 32, height: 32)
                }
                
                Text("\(item.quantity)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Theme.primary)
                    .frame(width: 28)
                
                Button(action: {
                    withAnimation { cartManager.incrementQuantity(item) }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Theme.primary)
                        .frame(width: 32, height: 32)
                }
            }
            .background(Theme.primary.opacity(0.1))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Theme.primary.opacity(0.3), lineWidth: 1)
            )
            
            Text("₹\(Int(item.price * Double(item.quantity)))")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .frame(width: 55, alignment: .trailing)
        }
        .padding(14)
    }
    
    // MARK: - Bill Section
    
    private var billSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bill Details")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            billRow(label: "Item Total", value: "₹\(Int(subtotal))")
            billRow(label: "Delivery Fee", value: "₹\(Int(deliveryFee))", valueColor: Theme.textSecondary)
            billRow(label: "Taxes & Charges", value: "₹\(Int(taxes))", valueColor: Theme.textSecondary)
            
            Divider().background(Theme.elevatedSurface)
            
            HStack {
                Text("To Pay")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Text("₹\(Int(grandTotal))")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerS)
    }
    
    private func billRow(label: String, value: String, valueColor: Color = Theme.textPrimary) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(valueColor)
        }
    }
    
    // MARK: - Delivery Info
    
    private var deliveryInfoSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "clock.fill")
                .foregroundColor(Theme.primary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Delivery in 25-30 min")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                Text("Standard delivery to Chhatarpur Farms")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
            }
            Spacer()
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerS)
    }
    
    // MARK: - Place Order Button
    
    private var placeOrderButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                orderPlaced = true
            }
            // Clear cart after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                cartManager.clearCart()
            }
        }) {
            HStack {
                Text("Place Order")
                    .font(.system(size: 17, weight: .bold))
                Text("•")
                Text("₹\(Int(grandTotal))")
                    .font(.system(size: 17, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [Color.green.opacity(0.9), Color(red: 0/255, green: 130/255, blue: 70/255)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(Theme.cornerM)
            .shadow(color: Color.green.opacity(0.3), radius: 10, y: 3)
        }
        .padding(.horizontal, Theme.paddingM)
        .padding(.vertical, 12)
        .background(Theme.surfaceBackground)
    }
    
    // MARK: - Empty Cart
    
    private var emptyCartView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "bag")
                .font(.system(size: 60))
                .foregroundColor(Theme.textMuted)
            
            Text("Your cart is empty")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            Text("Add items from a restaurant to get started")
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
            
            Button(action: { dismiss() }) {
                Text("Browse Restaurants")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(Theme.primary)
                    .cornerRadius(Theme.cornerS)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Order Success
    
    private var orderSuccessView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.15))
                    .frame(width: 120, height: 120)
                
                Circle()
                    .fill(Color.green.opacity(0.25))
                    .frame(width: 90, height: 90)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 56))
                    .foregroundColor(.green)
            }
            
            Text("Order Placed! 🎉")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            Text("Your food is being prepared.\nEstimated delivery in 25-30 min.")
                .font(.system(size: 15))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
            
            Button(action: { dismiss() }) {
                Text("Back to Home")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(Theme.primary)
                    .cornerRadius(Theme.cornerS)
            }
            .padding(.top, 8)
            
            Spacer()
        }
    }
}
