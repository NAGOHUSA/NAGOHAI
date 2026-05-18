import Foundation

struct TrendingTopic: Identifiable, Decodable {
    var id: String { title }
    let title: String
    let emoji: String
    let momentum: Momentum
    let context: String

    enum CodingKeys: String, CodingKey {
        case title, emoji, momentum, context
    }
}

enum Momentum: String, Codable {
    case trending
    case viral
    case rising
    case steady
    case evergreen

    var badge: String {
        switch self {
        case .trending:  return "🔥 TRENDING"
        case .viral:     return "🚀 VIRAL"
        case .rising:    return "📈 RISING"
        case .steady:    return "📈 STEADY"
        case .evergreen: return "♾️ EVERGREEN"
        }
    }

    var color: MomentumColor {
        switch self {
        case .trending, .viral, .rising: return .gold
        case .steady:                     return .teal
        case .evergreen:                  return .plum
        }
    }
}

enum MomentumColor {
    case gold, teal, plum
}

struct TrendingResponse: Decodable {
    let topics: [TrendingTopic]
    let industry: String
    let cached: Bool?
}
