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


// MARK: - Default Timeline (shown when no specific input)
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

// MARK: - Venue Database

/// A large database of venues, activities, and experiences for matching user input.
struct VenueDatabase {
    
    // MARK: - Breakfast & Cafes
    
    static let breakfastCafes: [Activity] = [
        Activity(name: "The Vintage Cafe", rating: "4.8", distance: "1.2 km", price: "₹400", image: "cafe", tags: ["Cozy", "Pastries"]),
        Activity(name: "Sunny Side Up", rating: "4.6", distance: "2.0 km", price: "₹350", image: "cafe2", tags: ["Outdoor Seating"]),
        Activity(name: "Dew Drops Cafe", rating: "4.5", distance: "1.8 km", price: "₹300", image: "cafe", tags: ["Healthy", "Smoothies"]),
        Activity(name: "Blue Tokai Coffee", rating: "4.7", distance: "2.5 km", price: "₹450", image: "coffee", tags: ["Artisan", "Coffee"]),
        Activity(name: "Third Wave Coffee", rating: "4.6", distance: "1.5 km", price: "₹350", image: "coffee", tags: ["Specialty", "Quiet"]),
        Activity(name: "Starbucks Reserve", rating: "4.4", distance: "3.0 km", price: "₹500", image: "coffee", tags: ["Premium", "WiFi"]),
        Activity(name: "Roasters & Co", rating: "4.9", distance: "0.8 km", price: "₹380", image: "coffee", tags: ["Artisan", "Quiet"]),
        Activity(name: "Chaayos", rating: "4.3", distance: "1.0 km", price: "₹250", image: "cafe", tags: ["Chai", "Snacks"]),
        Activity(name: "The Daily Grind", rating: "4.5", distance: "2.2 km", price: "₹320", image: "cafe", tags: ["Brunch", "Chill"]),
        Activity(name: "Wafflicious", rating: "4.6", distance: "1.6 km", price: "₹400", image: "cafe", tags: ["Waffles", "Instagram"])
    ]
    
    // MARK: - Restaurants & Dining
    
    static let restaurants: [Activity] = [
        Activity(name: "Lumina Fine Dining", rating: "5.0", distance: "3.2 km", price: "₹2500", image: "dining", tags: ["Fine Dining", "Romantic"]),
        Activity(name: "Green Leaf Bistro", rating: "4.7", distance: "1.0 km", price: "₹600", image: "salad", tags: ["Healthy", "Vegan"]),
        Activity(name: "Big Chill Cakery", rating: "4.8", distance: "4.0 km", price: "₹800", image: "dining", tags: ["Italian", "Cakes"]),
        Activity(name: "Burma Burma", rating: "4.7", distance: "3.5 km", price: "₹900", image: "dining", tags: ["Burmese", "Vegetarian"]),
        Activity(name: "Farzi Cafe", rating: "4.6", distance: "2.8 km", price: "₹1200", image: "dining", tags: ["Modern Indian", "Molecular"]),
        Activity(name: "Pa Pa Ya", rating: "4.8", distance: "5.0 km", price: "₹1500", image: "dining", tags: ["Asian", "Sushi"]),
        Activity(name: "Nando's", rating: "4.5", distance: "2.0 km", price: "₹700", image: "dining", tags: ["Peri Peri", "Chicken"]),
        Activity(name: "Social", rating: "4.4", distance: "1.5 km", price: "₹800", image: "dining", tags: ["Casual", "Drinks"]),
        Activity(name: "SodaBottleOpenerWala", rating: "4.6", distance: "3.0 km", price: "₹650", image: "dining", tags: ["Parsi", "Quirky"]),
        Activity(name: "Barbeque Nation", rating: "4.5", distance: "4.5 km", price: "₹1000", image: "dining", tags: ["Buffet", "BBQ"]),
        Activity(name: "Dhaba Estd 1986", rating: "4.7", distance: "3.8 km", price: "₹750", image: "dining", tags: ["North Indian", "Rustic"]),
        Activity(name: "Cafe Delhi Heights", rating: "4.5", distance: "2.5 km", price: "₹700", image: "dining", tags: ["Continental", "Lively"]),
        Activity(name: "Mamagoto", rating: "4.6", distance: "3.2 km", price: "₹800", image: "dining", tags: ["Pan-Asian", "Ramen"]),
        Activity(name: "Pizza Express", rating: "4.4", distance: "1.8 km", price: "₹600", image: "dining", tags: ["Pizza", "Italian"]),
        Activity(name: "Haldiram's", rating: "4.3", distance: "0.5 km", price: "₹300", image: "dining", tags: ["Indian Snacks", "Budget"])
    ]
    
    // MARK: - Street Food
    
    static let streetFood: [Activity] = [
        Activity(name: "Parathe Wali Gali", rating: "4.7", distance: "8.0 km", price: "₹150", image: "streetfood", tags: ["Iconic", "Parathas"]),
        Activity(name: "Chaat Corner", rating: "4.5", distance: "1.2 km", price: "₹100", image: "streetfood", tags: ["Golgappa", "Spicy"]),
        Activity(name: "Khan Chacha Kebabs", rating: "4.8", distance: "6.0 km", price: "₹250", image: "streetfood", tags: ["Kebabs", "Legendary"]),
        Activity(name: "Dilli 6 Street Food Hub", rating: "4.6", distance: "7.5 km", price: "₹200", image: "streetfood", tags: ["Variety", "Authentic"]),
        Activity(name: "Moolchand Parantha", rating: "4.4", distance: "4.0 km", price: "₹180", image: "streetfood", tags: ["Late Night", "Paranthas"]),
        Activity(name: "Al Jawahar", rating: "4.7", distance: "9.0 km", price: "₹350", image: "streetfood", tags: ["Mughlai", "Historic"])
    ]
    
    // MARK: - Adventure Activities
    
    static let adventureActivities: [Activity] = [
        Activity(name: "Urban Combat Arena", rating: "4.9", distance: "5.5 km", price: "₹1200", image: "paintball", tags: ["Paintball", "Top Rated"]),
        Activity(name: "ATV Ride Zone", rating: "4.7", distance: "12.0 km", price: "₹1500", image: "adventure", tags: ["ATV", "Off-Road"]),
        Activity(name: "Fly High Bungee", rating: "4.8", distance: "15.0 km", price: "₹2500", image: "adventure", tags: ["Bungee", "Thrill"]),
        Activity(name: "Rope Adventure Park", rating: "4.6", distance: "8.0 km", price: "₹800", image: "adventure", tags: ["Rope Course", "Outdoor"]),
        Activity(name: "Delhi Rock Climbing", rating: "4.5", distance: "6.0 km", price: "₹600", image: "adventure", tags: ["Climbing", "Indoor"]),
        Activity(name: "Zipline Valley", rating: "4.7", distance: "20.0 km", price: "₹1800", image: "adventure", tags: ["Zipline", "Scenic"]),
        Activity(name: "Skydive Gurugram", rating: "4.9", distance: "25.0 km", price: "₹8000", image: "adventure", tags: ["Skydiving", "Premium"]),
        Activity(name: "Trampoline Park NCR", rating: "4.6", distance: "7.0 km", price: "₹700", image: "adventure", tags: ["Trampoline", "Fun"]),
        Activity(name: "Laser Tag Arena", rating: "4.5", distance: "4.5 km", price: "₹500", image: "adventure", tags: ["Laser Tag", "Group"]),
        Activity(name: "Go Karting Hub", rating: "4.8", distance: "10.0 km", price: "₹900", image: "adventure", tags: ["Go Kart", "Racing"]),
        Activity(name: "Paintball Plus", rating: "4.6", distance: "6.5 km", price: "₹1000", image: "paintball", tags: ["Paintball", "Teams"]),
        Activity(name: "Escape Room Gurgaon", rating: "4.7", distance: "3.5 km", price: "₹800", image: "adventure", tags: ["Escape Room", "Puzzle"]),
        Activity(name: "Mystery Rooms", rating: "4.8", distance: "4.0 km", price: "₹750", image: "adventure", tags: ["Escape Room", "Thrilling"]),
        Activity(name: "Rifle Shooting Range", rating: "4.5", distance: "5.0 km", price: "₹600", image: "adventure", tags: ["Shooting", "Indoor"]),
        Activity(name: "Water Sports Complex", rating: "4.6", distance: "18.0 km", price: "₹1200", image: "adventure", tags: ["Kayaking", "Water Sports"])
    ]
    
    // MARK: - Arcade & Gaming
    
    static let arcadeGaming: [Activity] = [
        Activity(name: "Smaaash", rating: "4.7", distance: "3.0 km", price: "₹800", image: "arcade", tags: ["VR", "Bowling", "Arcade"]),
        Activity(name: "Timezone", rating: "4.5", distance: "2.5 km", price: "₹600", image: "arcade", tags: ["Arcade", "Prizes"]),
        Activity(name: "Fun City", rating: "4.4", distance: "4.0 km", price: "₹500", image: "arcade", tags: ["Arcade", "Family"]),
        Activity(name: "Game Palacio", rating: "4.6", distance: "5.0 km", price: "₹700", image: "arcade", tags: ["VR", "Simulation"]),
        Activity(name: "Hamleys Play", rating: "4.3", distance: "3.5 km", price: "₹450", image: "arcade", tags: ["Kids", "Play Zone"]),
        Activity(name: "VR World Experience", rating: "4.8", distance: "6.0 km", price: "₹1000", image: "arcade", tags: ["VR", "Immersive"]),
        Activity(name: "Play Arena", rating: "4.5", distance: "4.5 km", price: "₹550", image: "arcade", tags: ["Bowling", "Arcade"]),
        Activity(name: "iSKATE", rating: "4.7", distance: "3.8 km", price: "₹650", image: "arcade", tags: ["Ice Skating", "Indoor"]),
        Activity(name: "Snow World", rating: "4.4", distance: "5.5 km", price: "₹750", image: "arcade", tags: ["Snow", "Indoor"]),
        Activity(name: "Amoeba Board Game Cafe", rating: "4.8", distance: "2.0 km", price: "₹400", image: "arcade", tags: ["Board Games", "Cafe"]),
        Activity(name: "Console Gaming Lounge", rating: "4.6", distance: "2.8 km", price: "₹500", image: "arcade", tags: ["PS5", "Xbox", "Gaming"]),
        Activity(name: "E-Sports Arena", rating: "4.7", distance: "4.2 km", price: "₹600", image: "arcade", tags: ["E-Sports", "PC Gaming"])
    ]
    
    // MARK: - Movies & Entertainment
    
    static let movies: [Activity] = [
        Activity(name: "PVR LUXE", rating: "4.8", distance: "3.0 km", price: "₹500", image: "movie", tags: ["IMAX", "Premium"]),
        Activity(name: "PVR INOX", rating: "4.6", distance: "2.0 km", price: "₹350", image: "movie", tags: ["4DX", "Dolby Atmos"]),
        Activity(name: "Cinepolis VIP", rating: "4.7", distance: "4.5 km", price: "₹600", image: "movie", tags: ["VIP Lounge", "Recliner"]),
        Activity(name: "Movie Time Cinemas", rating: "4.3", distance: "1.5 km", price: "₹200", image: "movie", tags: ["Budget", "Snacks"]),
        Activity(name: "Carnival Cinemas", rating: "4.4", distance: "3.5 km", price: "₹250", image: "movie", tags: ["Affordable", "Family"]),
        Activity(name: "PVR Director's Cut", rating: "4.9", distance: "6.0 km", price: "₹1200", image: "movie", tags: ["Luxury", "Dining", "Premium"]),
        Activity(name: "INOX Megaplex", rating: "4.6", distance: "5.0 km", price: "₹400", image: "movie", tags: ["ScreenX", "Large Screen"]),
        Activity(name: "Open Air Cinema Club", rating: "4.8", distance: "8.0 km", price: "₹800", image: "movie", tags: ["Open Air", "Unique"]),
        Activity(name: "Drive-In Movie Night", rating: "4.7", distance: "12.0 km", price: "₹700", image: "movie", tags: ["Drive-In", "Retro", "Date Night"])
    ]
    
    // MARK: - Places to Visit & Sightseeing
    
    static let placesToVisit: [Activity] = [
        Activity(name: "India Gate", rating: "4.8", distance: "15.0 km", price: nil, image: "monument", tags: ["Iconic", "History"]),
        Activity(name: "Qutub Minar", rating: "4.7", distance: "12.0 km", price: "₹35", image: "monument", tags: ["UNESCO", "Architecture"]),
        Activity(name: "Humayun's Tomb", rating: "4.8", distance: "14.0 km", price: "₹35", image: "monument", tags: ["Mughal", "Gardens"]),
        Activity(name: "Lotus Temple", rating: "4.6", distance: "10.0 km", price: nil, image: "monument", tags: ["Peaceful", "Architecture"]),
        Activity(name: "Red Fort", rating: "4.7", distance: "18.0 km", price: "₹35", image: "monument", tags: ["History", "Iconic"]),
        Activity(name: "Akshardham Temple", rating: "4.9", distance: "16.0 km", price: nil, image: "monument", tags: ["Spiritual", "Grand"]),
        Activity(name: "Garden of Five Senses", rating: "4.5", distance: "8.0 km", price: "₹35", image: "park", tags: ["Nature", "Romantic"]),
        Activity(name: "Lodhi Garden", rating: "4.7", distance: "11.0 km", price: nil, image: "park", tags: ["Park", "Jogging"]),
        Activity(name: "Nehru Place Market", rating: "4.3", distance: "9.0 km", price: nil, image: "market", tags: ["Tech", "Shopping"]),
        Activity(name: "Dilli Haat", rating: "4.6", distance: "10.0 km", price: "₹30", image: "market", tags: ["Handicrafts", "Culture"]),
        Activity(name: "Hauz Khas Village", rating: "4.5", distance: "7.0 km", price: nil, image: "explore", tags: ["Cafes", "Art", "Ruins"]),
        Activity(name: "Chandni Chowk", rating: "4.6", distance: "17.0 km", price: nil, image: "market", tags: ["Street Food", "Shopping"]),
        Activity(name: "Kingdom of Dreams", rating: "4.7", distance: "6.0 km", price: "₹1500", image: "explore", tags: ["Shows", "Culture"]),
        Activity(name: "National Museum", rating: "4.5", distance: "13.0 km", price: "₹20", image: "museum", tags: ["History", "Art"]),
        Activity(name: "Rail Museum", rating: "4.4", distance: "12.0 km", price: "₹50", image: "museum", tags: ["Trains", "Kids"])
    ]
    
    // MARK: - Shopping
    
    static let shopping: [Activity] = [
        Activity(name: "Ambience Mall", rating: "4.6", distance: "5.0 km", price: nil, image: "mall", tags: ["Premium", "Brands"]),
        Activity(name: "DLF Cyber Hub", rating: "4.7", distance: "4.0 km", price: nil, image: "mall", tags: ["Restaurants", "Nightlife"]),
        Activity(name: "MGF Metropolitan", rating: "4.4", distance: "3.0 km", price: nil, image: "mall", tags: ["Shopping", "Movies"]),
        Activity(name: "Select City Walk", rating: "4.8", distance: "8.0 km", price: nil, image: "mall", tags: ["Luxury", "Open Air"]),
        Activity(name: "Sarojini Nagar Market", rating: "4.5", distance: "12.0 km", price: nil, image: "market", tags: ["Bargains", "Fashion"]),
        Activity(name: "Khan Market", rating: "4.7", distance: "14.0 km", price: nil, image: "market", tags: ["Premium", "Books"]),
        Activity(name: "DLF Mall of India", rating: "4.6", distance: "18.0 km", price: nil, image: "mall", tags: ["Largest", "Entertainment"]),
        Activity(name: "Pacific Mall", rating: "4.4", distance: "6.0 km", price: nil, image: "mall", tags: ["Shopping", "Food Court"])
    ]
    
    // MARK: - Nightlife & Bars
    
    static let nightlife: [Activity] = [
        Activity(name: "Cyber Hub Social", rating: "4.6", distance: "4.0 km", price: "₹1500", image: "bar", tags: ["Cocktails", "Rooftop"]),
        Activity(name: "Imperfecto", rating: "4.5", distance: "5.0 km", price: "₹1200", image: "bar", tags: ["Live Music", "Mediterranean"]),
        Activity(name: "Soi 7 Pub", rating: "4.7", distance: "3.5 km", price: "₹1000", image: "bar", tags: ["Beer", "Sports Bar"]),
        Activity(name: "Lord of the Drinks", rating: "4.4", distance: "4.5 km", price: "₹1300", image: "bar", tags: ["Party", "DJ"]),
        Activity(name: "Molecule Air Bar", rating: "4.8", distance: "6.0 km", price: "₹1800", image: "bar", tags: ["Rooftop", "Premium"]),
        Activity(name: "The Piano Man Jazz Club", rating: "4.9", distance: "8.0 km", price: "₹1500", image: "bar", tags: ["Jazz", "Live Music"]),
        Activity(name: "Raasta Cafe", rating: "4.5", distance: "3.0 km", price: "₹800", image: "bar", tags: ["Chill", "Hookah"]),
        Activity(name: "Prankster", rating: "4.6", distance: "4.2 km", price: "₹1100", image: "bar", tags: ["Quirky", "Cocktails"])
    ]
    
    // MARK: - Sports & Fitness
    
    static let sports: [Activity] = [
        Activity(name: "Smaaash Bowling", rating: "4.7", distance: "3.0 km", price: "₹500", image: "bowling", tags: ["Bowling", "Group"]),
        Activity(name: "Delhi Cricket Academy", rating: "4.6", distance: "6.0 km", price: "₹800", image: "sports", tags: ["Cricket", "Nets"]),
        Activity(name: "Box8 Football Arena", rating: "4.5", distance: "4.0 km", price: "₹600", image: "sports", tags: ["Football", "Turf"]),
        Activity(name: "Badminton Hub", rating: "4.4", distance: "2.5 km", price: "₹400", image: "sports", tags: ["Badminton", "Indoor"]),
        Activity(name: "Tennis Court Club", rating: "4.6", distance: "5.0 km", price: "₹700", image: "sports", tags: ["Tennis", "Coaching"]),
        Activity(name: "Swimming Pool Club", rating: "4.5", distance: "3.5 km", price: "₹500", image: "sports", tags: ["Swimming", "Pool"]),
        Activity(name: "CrossFit Box", rating: "4.7", distance: "2.0 km", price: "₹600", image: "sports", tags: ["CrossFit", "Fitness"]),
        Activity(name: "Yoga Retreat Studio", rating: "4.8", distance: "3.0 km", price: "₹400", image: "sports", tags: ["Yoga", "Wellness"])
    ]
    
    // MARK: - Spa & Wellness
    
    static let spaWellness: [Activity] = [
        Activity(name: "O2 Spa", rating: "4.6", distance: "3.0 km", price: "₹1500", image: "spa", tags: ["Massage", "Relax"]),
        Activity(name: "Thai Odyssey", rating: "4.7", distance: "4.5 km", price: "₹2000", image: "spa", tags: ["Thai Massage", "Premium"]),
        Activity(name: "Aura Thai Spa", rating: "4.5", distance: "2.5 km", price: "₹1200", image: "spa", tags: ["Couples", "Relaxing"]),
        Activity(name: "The White Door Spa", rating: "4.8", distance: "5.0 km", price: "₹2500", image: "spa", tags: ["Luxury", "Aromatherapy"]),
        Activity(name: "Tattva Spa", rating: "4.6", distance: "3.5 km", price: "₹1800", image: "spa", tags: ["Ayurveda", "Traditional"])
    ]
    
    // MARK: - All Venues (flat list for text matching)
    
    static let allVenues: [Activity] = breakfastCafes + restaurants + streetFood + adventureActivities + arcadeGaming + movies + placesToVisit + shopping + nightlife + sports + spaWellness
}

// MARK: - Text Parser Service

/// Parses user-typed itinerary text and builds a matching timeline from the venue database.
class TextParserService {
    
    /// Category groupings with their keywords and icons
    private struct CategoryMatch {
        let title: String
        let icon: String
        let keywords: [String]
        let venues: [Activity]
    }
    
    /// Parses the user's plan text and returns a matching timeline.
    func parse(text: String) -> [TimelineBlock] {
        let lowered = text.lowercased()
        
        let categories: [CategoryMatch] = [
            CategoryMatch(title: "Breakfast", icon: "🥞",
                          keywords: ["breakfast", "brunch", "morning", "cafe", "coffee", "chai", "tea", "waffle", "pancake"],
                          venues: VenueDatabase.breakfastCafes),
            
            CategoryMatch(title: "Adventure", icon: "🎯",
                          keywords: ["paintball", "adventure", "bungee", "zipline", "atv", "skydive", "climbing", "trampoline", "laser tag", "go kart", "karting", "escape room", "shooting"],
                          venues: VenueDatabase.adventureActivities),
            
            CategoryMatch(title: "Arcade & Gaming", icon: "🕹️",
                          keywords: ["arcade", "gaming", "vr", "bowling", "game", "play", "smaaash", "timezone", "board game", "skating", "ice skating", "snow", "ps5", "xbox", "esport", "e-sport"],
                          venues: VenueDatabase.arcadeGaming),
            
            CategoryMatch(title: "Movie", icon: "🎬",
                          keywords: ["movie", "cinema", "film", "imax", "pvr", "inox", "watch", "show", "theatre", "theater", "drive-in"],
                          venues: VenueDatabase.movies),
            
            CategoryMatch(title: "Lunch", icon: "🥗",
                          keywords: ["lunch", "meal", "eat", "food", "restaurant", "biryani", "pizza", "burger", "ramen", "noodles", "north indian", "chinese", "italian"],
                          venues: VenueDatabase.restaurants),
            
            CategoryMatch(title: "Street Food", icon: "🍜",
                          keywords: ["street food", "chaat", "golgappa", "kebab", "paratha", "parantha", "dilli", "chandni chowk"],
                          venues: VenueDatabase.streetFood),
            
            CategoryMatch(title: "Places to Visit", icon: "🏛️",
                          keywords: ["visit", "sightseeing", "monument", "temple", "fort", "museum", "gate", "garden", "park", "historic", "ruins", "explore", "tourist", "place", "hauz khas", "market"],
                          venues: VenueDatabase.placesToVisit),
            
            CategoryMatch(title: "Shopping", icon: "🛍️",
                          keywords: ["shop", "shopping", "mall", "market", "fashion", "clothes", "buy", "brand"],
                          venues: VenueDatabase.shopping),
            
            CategoryMatch(title: "Sports", icon: "⚽",
                          keywords: ["sport", "cricket", "football", "badminton", "tennis", "swim", "yoga", "gym", "fitness", "crossfit"],
                          venues: VenueDatabase.sports),
            
            CategoryMatch(title: "Spa & Wellness", icon: "🧖",
                          keywords: ["spa", "massage", "relax", "wellness", "therapy", "ayurveda"],
                          venues: VenueDatabase.spaWellness),
            
            CategoryMatch(title: "Dinner", icon: "🍽️",
                          keywords: ["dinner", "fine dining", "romantic", "date night", "candlelight", "evening meal"],
                          venues: VenueDatabase.restaurants),
            
            CategoryMatch(title: "Nightlife", icon: "🍷",
                          keywords: ["night", "bar", "pub", "club", "drink", "cocktail", "beer", "wine", "rooftop", "party", "dj", "jazz", "hookah", "lounge"],
                          venues: VenueDatabase.nightlife)
        ]
        
        // Find matching categories
        var matchedBlocks: [TimelineBlock] = []
        var usedTitles: Set<String> = []
        var hour = 10
        
        for category in categories {
            let isMatch = category.keywords.contains { keyword in
                lowered.contains(keyword)
            }
            
            // Also check for direct venue name matches
            let venueNameMatch = category.venues.contains { venue in
                lowered.contains(venue.name.lowercased())
            }
            
            if (isMatch || venueNameMatch) && !usedTitles.contains(category.title) {
                usedTitles.insert(category.title)
                
                // Pick up to 3 matching venues, prioritizing name matches
                var selectedVenues = category.venues.filter { venue in
                    lowered.contains(venue.name.lowercased())
                }
                
                // Fill remaining slots with top-rated venues
                if selectedVenues.count < 3 {
                    let remaining = category.venues
                        .filter { !selectedVenues.contains($0) }
                        .sorted { ($0.rating as NSString).doubleValue > ($1.rating as NSString).doubleValue }
                        .prefix(3 - selectedVenues.count)
                    selectedVenues.append(contentsOf: remaining)
                }
                
                matchedBlocks.append(TimelineBlock(
                    time: formatTime(hour),
                    title: category.title,
                    icon: category.icon,
                    items: Array(selectedVenues.prefix(3))
                ))
                
                hour += 2
            }
        }
        
        // If nothing matched, return a default day
        if matchedBlocks.isEmpty {
            return buildDefaultDay()
        }
        
        return matchedBlocks
    }
    
    private func formatTime(_ hour: Int) -> String {
        let h = hour % 12 == 0 ? 12 : hour % 12
        let period = hour >= 12 ? "PM" : "AM"
        return "\(h):00 \(period)"
    }
    
    private func buildDefaultDay() -> [TimelineBlock] {
        [
            TimelineBlock(time: "10:00 AM", title: "Breakfast", icon: "🥞", items: Array(VenueDatabase.breakfastCafes.prefix(2))),
            TimelineBlock(time: "12:00 PM", title: "Explore", icon: "🏛️", items: Array(VenueDatabase.placesToVisit.prefix(2))),
            TimelineBlock(time: "2:00 PM", title: "Lunch", icon: "🥗", items: Array(VenueDatabase.restaurants.prefix(2))),
            TimelineBlock(time: "4:00 PM", title: "Entertainment", icon: "🕹️", items: Array(VenueDatabase.arcadeGaming.prefix(2))),
            TimelineBlock(time: "8:00 PM", title: "Dinner", icon: "🍽️", items: Array(VenueDatabase.restaurants.suffix(2)))
        ]
    }
}
