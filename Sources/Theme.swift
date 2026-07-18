import SwiftUI

// MARK: - Design Tokens

enum Theme {
    // Primary
    static let primary = Color(red: 184/255, green: 164/255, blue: 248/255)
    static let primaryDark = Color(red: 140/255, green: 110/255, blue: 230/255)
    static let accent = Color.purple
    
    // Backgrounds
    static let background = Color(red: 18/255, green: 18/255, blue: 24/255)
    static let cardBackground = Color(red: 30/255, green: 30/255, blue: 40/255)
    static let surfaceBackground = Color(red: 24/255, green: 24/255, blue: 32/255)
    static let elevatedSurface = Color(red: 38/255, green: 38/255, blue: 50/255)
    
    // Text
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.6)
    static let textMuted = Color(white: 0.4)
    
    // Gradients
    static let primaryGradient = LinearGradient(
        colors: [primary, accent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [cardBackground, Color(red: 35/255, green: 30/255, blue: 50/255)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let heroGradient = LinearGradient(
        colors: [
            Color(red: 60/255, green: 20/255, blue: 120/255).opacity(0.6),
            background
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Spacing
    static let paddingS: CGFloat = 8
    static let paddingM: CGFloat = 16
    static let paddingL: CGFloat = 24
    static let paddingXL: CGFloat = 32
    
    // Corner Radius
    static let cornerS: CGFloat = 12
    static let cornerM: CGFloat = 16
    static let cornerL: CGFloat = 24
    static let cornerXL: CGFloat = 32
}

// MARK: - View Modifiers

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Theme.paddingM)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerL)
    }
}

struct ElevatedCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Theme.paddingL)
            .background(Theme.elevatedSurface)
            .cornerRadius(Theme.cornerL)
            .shadow(color: Color.black.opacity(0.3), radius: 10, y: 5)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
    
    func elevatedCardStyle() -> some View {
        modifier(ElevatedCardStyle())
    }
}
