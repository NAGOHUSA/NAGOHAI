import Foundation

struct AnalyticsData: Decodable {
    let totalContent: Int
    let avgEngagement: Int
    let bestFormat: String
    let avgCreationTime: String
    let trendLabels: [String]
    let trendData: [Int]
    let engagementLabels: [String]
    let engagementData: [Int]
    let editingLabels: [String]
    let editingData: [Int]
    let topicLabels: [String]
    let topicData: [Int]
    let breakdown: [ContentTypeBreakdown]
    let insights: [String]

    enum CodingKeys: String, CodingKey {
        case totalContent      = "total_content"
        case avgEngagement     = "avg_engagement"
        case bestFormat        = "best_format"
        case avgCreationTime   = "avg_creation_time"
        case trendLabels       = "trend_labels"
        case trendData         = "trend_data"
        case engagementLabels  = "engagement_labels"
        case engagementData    = "engagement_data"
        case editingLabels     = "editing_labels"
        case editingData       = "editing_data"
        case topicLabels       = "topic_labels"
        case topicData         = "topic_data"
        case breakdown, insights
    }
}

struct ContentTypeBreakdown: Decodable, Identifiable {
    var id: String { type }
    let type: String
    let count: Int
    let edits: Int
    let engagement: Int
    let exports: Int
}

// MARK: – Demo Data

extension AnalyticsData {
    static let demo = AnalyticsData(
        totalContent: 47,
        avgEngagement: 72,
        bestFormat: "Social",
        avgCreationTime: "2.3 min",
        trendLabels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
        trendData: [3, 7, 5, 12, 8, 6, 10],
        engagementLabels: ["Social", "Email", "Blog", "Quote"],
        engagementData: [84, 61, 73, 55],
        editingLabels: ["0×", "1×", "2×", "3×+"],
        editingData: [18, 14, 9, 6],
        topicLabels: ["Products", "Tips", "Stories", "Promos", "Events"],
        topicData: [15, 12, 8, 7, 5],
        breakdown: [
            ContentTypeBreakdown(type: "Social", count: 21, edits: 38, engagement: 84, exports: 17),
            ContentTypeBreakdown(type: "Email",  count: 12, edits: 19, engagement: 61, exports: 11),
            ContentTypeBreakdown(type: "Blog",   count: 9,  edits: 15, engagement: 73, exports: 7),
            ContentTypeBreakdown(type: "Quote",  count: 5,  edits: 4,  engagement: 55, exports: 4),
        ],
        insights: [
            "Your Social content has the highest engagement at 84% — keep creating more!",
            "Wednesday and Friday are your most productive days.",
            "Most of your content needs only 0–1 edits — great quality on first draft.",
            "Products and Tips are your top-performing topic categories.",
        ]
    )
}

enum AnalyticsPeriod: String, CaseIterable, Identifiable {
    case week    = "week"
    case month   = "month"
    case quarter = "quarter"
    case year    = "year"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .week:    return "7 Days"
        case .month:   return "30 Days"
        case .quarter: return "90 Days"
        case .year:    return "1 Year"
        }
    }
}
