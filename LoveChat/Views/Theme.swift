import SwiftUI

enum LoveTheme {
    static let blush = Color(red: 1.00, green: 0.78, blue: 0.88)
    static let lavender = Color(red: 0.72, green: 0.58, blue: 1.00)
    static let lilac = Color(red: 0.86, green: 0.75, blue: 1.00)
    static let plum = Color(red: 0.46, green: 0.22, blue: 0.66)
    static let rose = Color(red: 1.00, green: 0.38, blue: 0.66)

    static let background = LinearGradient(
        colors: [Color(red: 1.00, green: 0.90, blue: 0.95), Color(red: 0.91, green: 0.86, blue: 1.00)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let myBubble = LinearGradient(
        colors: [rose, lavender],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let partnerBubble = LinearGradient(
        colors: [Color.white.opacity(0.95), Color(red: 1.00, green: 0.91, blue: 0.96).opacity(0.95)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
