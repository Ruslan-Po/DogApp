import SwiftUI

extension Color {
    // MARK: - Original Palette
    
    static let petzenBeige = Color(red: 232/255, green: 204/255, blue: 173/255)
    static let petzenOrange = Color(red: 236/255, green: 128/255, blue: 43/255)
    static let petzenYellow = Color(red: 237/255, green: 197/255, blue: 91/255)
    static let petzenTeal = Color(red: 102/255, green: 188/255, blue: 180/255)
    
    // MARK: - Extended Palette
    static let petzenBrown = Color(red: 139/255, green: 90/255, blue: 60/255)
    static let petzenCream = Color(red: 255/255, green: 248/255, blue: 231/255)
    static let petzenCoral = Color(red: 231/255, green: 111/255, blue: 81/255)
    static let petzenOlive = Color(red: 148/255, green: 166/255, blue: 132/255)
    
    // MARK: - Semantic
    static let brandPrimary = petzenYellow
    static let brandAccent = petzenOrange
    static let brandBackground = petzenBeige
    static let brandBackgroundLight = petzenCream
    static let brandInfo = petzenTeal
    static let brandText = petzenBrown
    static let brandSuccess = petzenOlive
    static let brandError = petzenCoral
    
    static let textPrimary = petzenBrown
    static let textSecondary = petzenBrown.opacity(0.7)
    static let textTertiary = petzenBrown.opacity(0.5)
}
