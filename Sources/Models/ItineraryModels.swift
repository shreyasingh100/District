import Foundation

struct Activity: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let rating: String
    let distance: String
    let price: String?
    let image: String
    let tags: [String]
}

struct TimelineBlock: Identifiable, Hashable {
    let id = UUID()
    let time: String
    let title: String
    let icon: String
    let items: [Activity]
}

class MockData {
    static let timeline: [TimelineBlock] = [
        TimelineBlock(time: "10:00 AM", title: "Breakfast", icon: "🥞", items: [
            Activity(name: "The Vintage Cafe", rating: "4.8", distance: "1.2 km", price: nil, image: "cafe", tags: ["Cozy", "Pastries"]),
            Activity(name: "Sunny Side Up", rating: "4.6", distance: "2.0 km", price: nil, image: "cafe2", tags: ["Outdoor Seating"])
        ]),
        TimelineBlock(time: "11:30 AM", title: "Paintball", icon: "🎯", items: [
            Activity(name: "Urban Combat Arena", rating: "4.9", distance: "5.5 km", price: "₹1200", image: "paintball", tags: ["Top Rated"])
        ]),
        TimelineBlock(time: "2:00 PM", title: "Lunch", icon: "🥗", items: [
            Activity(name: "Green Leaf Bistro", rating: "4.7", distance: "1.0 km", price: nil, image: "salad", tags: ["Healthy", "Vegan"])
        ]),
        TimelineBlock(time: "4:00 PM", title: "Cafe Date", icon: "☕", items: [
            Activity(name: "Roasters & Co", rating: "4.9", distance: "0.8 km", price: nil, image: "coffee", tags: ["Artisan", "Quiet"])
        ]),
        TimelineBlock(time: "8:00 PM", title: "Dinner", icon: "🍷", items: [
            Activity(name: "Lumina Fine Dining", rating: "5.0", distance: "3.2 km", price: nil, image: "dining", tags: ["Fine Dining", "Romantic"])
        ])
    ]
}
