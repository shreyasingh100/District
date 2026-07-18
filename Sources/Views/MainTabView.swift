import SwiftUI

struct MainTabView: View {
    @StateObject private var cartManager = CartManager()
    @StateObject private var itineraryStore = ItineraryStore()

    var body: some View {
        TabView {
            FoodHomeScreen()
                .tabItem {
                    Label("Explore", systemImage: "fork.knife")
                }

            PlannerTabScreen()
                .tabItem {
                    Label("Plan", systemImage: "checklist.checked")
                }
        }
        .environmentObject(cartManager)
        .environmentObject(itineraryStore)
    }
}
