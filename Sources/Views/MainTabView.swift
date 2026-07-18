import SwiftUI

struct MainTabView: View {
    @StateObject private var cartManager = CartManager()
    @StateObject private var itineraryStore = ItineraryStore()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab Content
            Group {
                if selectedTab == 0 {
                    FoodHomeScreen()
                } else {
                    PlannerTabScreen()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom Tab Bar
            customTabBar
        }
        .background(Theme.background)
        .environmentObject(cartManager)
        .environmentObject(itineraryStore)
    }
    
    private var customTabBar: some View {
        HStack(spacing: 0) {
            tabButton(
                title: "Explore",
                icon: "fork.knife",
                isSelected: selectedTab == 0,
                action: { selectedTab = 0 }
            )
            
            tabButton(
                title: "Plan",
                icon: "sparkles",
                isSelected: selectedTab == 1,
                action: { selectedTab = 1 }
            )
        }
        .padding(.horizontal, Theme.paddingL)
        .padding(.top, 12)
        .padding(.bottom, 28)
        .background(
            Theme.surfaceBackground
                .shadow(color: Color.black.opacity(0.4), radius: 20, y: -5)
        )
    }
    
    private func tabButton(title: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
        }) {
            VStack(spacing: 6) {
                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(Theme.primary.opacity(0.2))
                            .frame(width: 64, height: 32)
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: isSelected ? .bold : .regular))
                        .foregroundColor(isSelected ? Theme.primary : Theme.textMuted)
                }
                
                Text(title)
                    .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? Theme.primary : Theme.textMuted)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
