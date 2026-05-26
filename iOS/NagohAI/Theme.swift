import SwiftUI

// MARK: - Color Palette

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: 1)
    }
}

enum NagohTheme {
    // Neutrals
    static let cream      = Color(hex: "fdf8f0")
    static let parchment  = Color(hex: "f5ede0")
    static let warm       = Color(hex: "ede3d5")
    static let border     = Color(hex: "e0d4c4")
    static let border2    = Color(hex: "d4c4b0")
    static let muted      = Color(hex: "b5a090")
    static let dim        = Color(hex: "8a7868")
    static let sub        = Color(hex: "6b5e50")
    static let ink        = Color(hex: "3d2f24")
    static let deep       = Color(hex: "2a1f16")

    // Accents
    static let rose       = Color(hex: "e8524a")
    static let roseLt     = Color(hex: "fce8e7")
    static let roseMd     = Color(hex: "f5c4c2")
    static let teal       = Color(hex: "2a9d8f")
    static let tealLt     = Color(hex: "e0f5f3")
    static let tealMd     = Color(hex: "a0dcd6")
    static let gold       = Color(hex: "e9a028")
    static let goldLt     = Color(hex: "fdf0d5")
    static let goldMd     = Color(hex: "f7d08a")
    static let sage       = Color(hex: "4a7c59")
    static let sageLt     = Color(hex: "e8f4eb")
    static let plum       = Color(hex: "8b5cf6")
    static let plumLt     = Color(hex: "f0ebff")

    // Typography
    // Note: bundle Fraunces-Regular.ttf / Fraunces-Italic.ttf for full fidelity.
    // Falls back to Georgia (system serif) if not bundled.
    static func serif(_ size: CGFloat, weight: Font.Weight = .regular, italic: Bool = false) -> Font {
        let base = Font.custom("Fraunces-Regular", size: size)
        return italic ? base.italic() : base
    }

    static func sans(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
}

// MARK: - View Modifiers

struct NagohCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(NagohTheme.border, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
    }
}

extension View {
    func nagohCard() -> some View {
        modifier(NagohCardModifier())
    }
}
