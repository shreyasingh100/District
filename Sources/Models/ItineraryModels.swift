import Foundation
import CoreLocation

struct Activity: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let rating: String
    let distance: String
    let price: String?
    let image: String
    let tags: [String]
    let coordinate: CLLocationCoordinate2D
    
    // Hashable conformance for CLLocationCoordinate2D
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Activity, rhs: Activity) -> Bool {
        lhs.id == rhs.id
    }
}

struct TimelineBlock: Identifiable, Hashable {
    let id = UUID()
    let time: String
    let title: String
    let icon: String
    let items: [Activity]
}

struct Itinerary: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let date: Date
    let timeline: [TimelineBlock]
    var isFinalized: Bool
    
    var stopCount: Int {
        timeline.count
    }
    
    var summary: String {
        timeline.map { $0.title }.joined(separator: " → ")
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Itinerary, rhs: Itinerary) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Cart Models

struct CartItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let price: Double
    var quantity: Int
    let restaurantName: String
}

struct Restaurant: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let rating: String
    let distance: String
    let cuisine: String
    let deliveryTime: String
    let imageSystemName: String
    let promoted: Bool
    let menuItems: [MenuItem]
}

struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double
    let isVeg: Bool
    let isBestseller: Bool
}

// MARK: - Mock Data

class MockData {
    static let timeline: [TimelineBlock] = [
        TimelineBlock(time: "10:00 AM", title: "Breakfast", icon: "🥞", items: [
            Activity(name: "The Vintage Cafe", rating: "4.8", distance: "1.2 km", price: nil, image: "cafe", tags: ["Cozy", "Pastries"], coordinate: CLLocationCoordinate2D(latitude: 28.5085, longitude: 77.1735)),
            Activity(name: "Sunny Side Up", rating: "4.6", distance: "2.0 km", price: nil, image: "cafe2", tags: ["Outdoor Seating"], coordinate: CLLocationCoordinate2D(latitude: 28.5120, longitude: 77.1790))
        ]),
        TimelineBlock(time: "11:30 AM", title: "Paintball", icon: "🎯", items: [
            Activity(name: "Urban Combat Arena", rating: "4.9", distance: "5.5 km", price: "₹1200", image: "paintball", tags: ["Top Rated"], coordinate: CLLocationCoordinate2D(latitude: 28.4950, longitude: 77.1850))
        ]),
        TimelineBlock(time: "2:00 PM", title: "Lunch", icon: "🥗", items: [
            Activity(name: "Green Leaf Bistro", rating: "4.7", distance: "1.0 km", price: nil, image: "salad", tags: ["Healthy", "Vegan"], coordinate: CLLocationCoordinate2D(latitude: 28.5050, longitude: 77.1680))
        ]),
        TimelineBlock(time: "4:00 PM", title: "Cafe Date", icon: "☕", items: [
            Activity(name: "Roasters & Co", rating: "4.9", distance: "0.8 km", price: nil, image: "coffee", tags: ["Artisan", "Quiet"], coordinate: CLLocationCoordinate2D(latitude: 28.5010, longitude: 77.1720))
        ]),
        TimelineBlock(time: "8:00 PM", title: "Dinner", icon: "🍷", items: [
            Activity(name: "Lumina Fine Dining", rating: "5.0", distance: "3.2 km", price: nil, image: "dining", tags: ["Fine Dining", "Romantic"], coordinate: CLLocationCoordinate2D(latitude: 28.4980, longitude: 77.1900))
        ])
    ]
    
    static let restaurants: [Restaurant] = [
        Restaurant(
            name: "The Vintage Cafe",
            rating: "4.8",
            distance: "1.2 km",
            cuisine: "Continental • Cafe",
            deliveryTime: "25 min",
            imageSystemName: "cup.and.saucer.fill",
            promoted: true,
            menuItems: [
                MenuItem(name: "Classic Pancakes", description: "Fluffy buttermilk pancakes with maple syrup", price: 249, isVeg: true, isBestseller: true),
                MenuItem(name: "Eggs Benedict", description: "Poached eggs on English muffin with hollandaise", price: 349, isVeg: false, isBestseller: true),
                MenuItem(name: "Avocado Toast", description: "Sourdough toast with smashed avocado and cherry tomatoes", price: 299, isVeg: true, isBestseller: false),
                MenuItem(name: "French Toast", description: "Brioche french toast with berries and cream", price: 279, isVeg: true, isBestseller: false),
                MenuItem(name: "Chicken Club Sandwich", description: "Triple-decker with grilled chicken, bacon, lettuce", price: 399, isVeg: false, isBestseller: true)
            ]
        ),
        Restaurant(
            name: "Green Leaf Bistro",
            rating: "4.7",
            distance: "1.0 km",
            cuisine: "Healthy • Salads • Bowls",
            deliveryTime: "20 min",
            imageSystemName: "leaf.fill",
            promoted: false,
            menuItems: [
                MenuItem(name: "Buddha Bowl", description: "Quinoa, roasted veggies, tahini dressing", price: 349, isVeg: true, isBestseller: true),
                MenuItem(name: "Grilled Chicken Salad", description: "Mixed greens, grilled chicken, balsamic vinaigrette", price: 399, isVeg: false, isBestseller: false),
                MenuItem(name: "Smoothie Bowl", description: "Acai, banana, granola, fresh fruits", price: 299, isVeg: true, isBestseller: true),
                MenuItem(name: "Falafel Wrap", description: "Crispy falafel, hummus, pickled veggies in pita", price: 279, isVeg: true, isBestseller: false)
            ]
        ),
        Restaurant(
            name: "Spice Route",
            rating: "4.5",
            distance: "2.5 km",
            cuisine: "North Indian • Mughlai",
            deliveryTime: "35 min",
            imageSystemName: "flame.fill",
            promoted: true,
            menuItems: [
                MenuItem(name: "Butter Chicken", description: "Tender chicken in rich tomato-butter gravy", price: 449, isVeg: false, isBestseller: true),
                MenuItem(name: "Paneer Tikka", description: "Chargrilled cottage cheese with spices", price: 349, isVeg: true, isBestseller: true),
                MenuItem(name: "Dal Makhani", description: "Slow-cooked black lentils in creamy gravy", price: 299, isVeg: true, isBestseller: false),
                MenuItem(name: "Biryani", description: "Fragrant basmati rice with aromatic spices", price: 399, isVeg: false, isBestseller: true),
                MenuItem(name: "Garlic Naan", description: "Tandoor-baked naan with garlic butter", price: 79, isVeg: true, isBestseller: false)
            ]
        ),
        Restaurant(
            name: "Roasters & Co",
            rating: "4.9",
            distance: "0.8 km",
            cuisine: "Coffee • Desserts",
            deliveryTime: "15 min",
            imageSystemName: "mug.fill",
            promoted: false,
            menuItems: [
                MenuItem(name: "Signature Cold Brew", description: "24-hour steeped cold brew coffee", price: 199, isVeg: true, isBestseller: true),
                MenuItem(name: "Tiramisu", description: "Classic Italian coffee-flavored dessert", price: 349, isVeg: true, isBestseller: true),
                MenuItem(name: "Hazelnut Latte", description: "Espresso with steamed milk and hazelnut", price: 249, isVeg: true, isBestseller: false),
                MenuItem(name: "Red Velvet Cake", description: "Moist red velvet with cream cheese frosting", price: 299, isVeg: true, isBestseller: false)
            ]
        ),
        Restaurant(
            name: "Lumina Fine Dining",
            rating: "5.0",
            distance: "3.2 km",
            cuisine: "Italian • Fine Dining",
            deliveryTime: "45 min",
            imageSystemName: "wineglass.fill",
            promoted: true,
            menuItems: [
                MenuItem(name: "Truffle Risotto", description: "Arborio rice with black truffle and parmesan", price: 799, isVeg: true, isBestseller: true),
                MenuItem(name: "Grilled Sea Bass", description: "Pan-seared sea bass with lemon butter sauce", price: 899, isVeg: false, isBestseller: true),
                MenuItem(name: "Lobster Ravioli", description: "Handmade ravioli with lobster filling", price: 999, isVeg: false, isBestseller: false),
                MenuItem(name: "Chocolate Fondant", description: "Warm chocolate cake with molten center", price: 499, isVeg: true, isBestseller: true)
            ]
        )
    ]
    
    static let sampleHistory: [Itinerary] = [
        Itinerary(title: "Weekend Brunch & Fun", date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, timeline: Array(timeline.prefix(3)), isFinalized: true),
        Itinerary(title: "Date Night Plan", date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, timeline: Array(timeline.suffix(2)), isFinalized: true),
        Itinerary(title: "Friends Day Out", date: Calendar.current.date(byAdding: .day, value: -14, to: Date())!, timeline: timeline, isFinalized: true)
    ]
}
