import SwiftUI

// MARK: – Brand Palette

extension Color {
    // Backgrounds
    static let nagohCream    = Color(red: 0.992, green: 0.969, blue: 0.941) // #fdf8f0
    static let nagohParchmt  = Color(red: 0.961, green: 0.929, blue: 0.878) // #f5ede0
    static let nagohWarm     = Color(red: 0.929, green: 0.890, blue: 0.835) // #ede3d5
    static let nagohBorder   = Color(red: 0.878, green: 0.831, blue: 0.769) // #e0d4c4

    // Text
    static let nagohInk      = Color(red: 0.239, green: 0.184, blue: 0.141) // #3d2f24
    static let nagohDeep     = Color(red: 0.165, green: 0.122, blue: 0.086) // #2a1f16
    static let nagohDim      = Color(red: 0.541, green: 0.471, blue: 0.408) // #8a7868
    static let nagohMuted    = Color(red: 0.710, green: 0.627, blue: 0.565) // #b5a090

    // Accent
    static let nagohGold     = Color(red: 0.914, green: 0.627, blue: 0.157) // #e9a028
    static let nagohGoldLt   = Color(red: 0.992, green: 0.941, blue: 0.835) // #fdf0d5
    static let nagohTeal     = Color(red: 0.165, green: 0.616, blue: 0.561) // #2a9d8f
    static let nagohTealLt   = Color(red: 0.878, green: 0.961, blue: 0.953) // #e0f5f3
    static let nagohRose     = Color(red: 0.910, green: 0.322, blue: 0.290) // #e8524a
    static let nagohRoseLt   = Color(red: 0.988, green: 0.910, blue: 0.906) // #fce8e7
    static let nagohPlum     = Color(red: 0.545, green: 0.361, blue: 0.965) // #8b5cf6
    static let nagohPlumLt   = Color(red: 0.941, green: 0.922, blue: 1.000) // #f0ebff
    static let nagohSage     = Color(red: 0.290, green: 0.486, blue: 0.349) // #4a7c59
    static let nagohSageLt   = Color(red: 0.910, green: 0.957, blue: 0.922) // #e8f4eb
}

// MARK: – Semantic shortcuts

extension Color {
    static let background   = Color.nagohCream
    static let cardBg       = Color.white
    static let accent       = Color.nagohTeal
    static let accentAlt    = Color.nagohGold
    static let primaryText  = Color.nagohInk
    static let secondaryText = Color.nagohDim
    static let border       = Color.nagohBorder
}

// MARK: – MomentumColor → SwiftUI Color

extension MomentumColor {
    var foreground: Color {
        switch self {
        case .gold: return .nagohGold
        case .teal: return .nagohTeal
        case .plum: return .nagohPlum
        }
    }
    var background: Color {
        switch self {
        case .gold: return .nagohGoldLt
        case .teal: return .nagohTealLt
        case .plum: return .nagohPlumLt
        }
    }
}
