import Foundation

@MainActor
final class TrendingViewModel: ObservableObject {
    @Published var topics: [TrendingTopic] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedIndustry: Industry = .etsy

    private let api = APIClient.shared

    func loadTopics() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response = try await api.fetchTrending(industry: selectedIndustry)
            topics = response.topics
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            // Show fallback static topics so the screen is never empty
            topics = fallbackTopics(for: selectedIndustry)
        }
    }

    func refresh() async {
        await loadTopics()
    }

    func changeIndustry(_ industry: Industry) {
        selectedIndustry = industry
        Task { await loadTopics() }
    }

    // MARK: – Static fallback topics

    private func fallbackTopics(for industry: Industry) -> [TrendingTopic] {
        switch industry {
        case .etsy:
            return [
                TrendingTopic(title: "Personalized Gifts",    emoji: "🎁", momentum: .trending,  context: "Custom items drive 40% more sales during gifting seasons."),
                TrendingTopic(title: "Sustainable Materials", emoji: "♻️", momentum: .rising,    context: "Eco-conscious buyers actively filter for sustainable products."),
                TrendingTopic(title: "Handmade Story",        emoji: "📖", momentum: .evergreen, context: "Behind-the-scenes content builds authentic connections."),
                TrendingTopic(title: "Seasonal Collections",  emoji: "🍂", momentum: .trending,  context: "Seasonal shops see 3× higher engagement."),
                TrendingTopic(title: "Bundle Deals",          emoji: "🛍️", momentum: .steady,    context: "Bundles increase average order value significantly."),
            ]
        case .realtor:
            return [
                TrendingTopic(title: "Interest Rate Updates",   emoji: "📊", momentum: .trending,  context: "Buyers are anxiously watching rate changes."),
                TrendingTopic(title: "Home Staging Tips",       emoji: "🏡", momentum: .evergreen, context: "Staged homes sell 73% faster."),
                TrendingTopic(title: "First-Time Buyer Guide",  emoji: "🔑", momentum: .steady,    context: "Educational content positions you as the trusted expert."),
                TrendingTopic(title: "Neighborhood Spotlight",  emoji: "📍", momentum: .trending,  context: "Hyperlocal content drives targeted leads."),
                TrendingTopic(title: "Investment Properties",   emoji: "💰", momentum: .rising,    context: "Investor activity is up 22% this quarter."),
            ]
        default:
            return [
                TrendingTopic(title: "Personal Brand Stories",  emoji: "👤", momentum: .trending,  context: "Personal narratives build stronger audience connections."),
                TrendingTopic(title: "Quick Tips & Hacks",      emoji: "⚡", momentum: .evergreen, context: "Short-form educational content always performs well."),
                TrendingTopic(title: "Industry Predictions",    emoji: "🔮", momentum: .trending,  context: "Forward-looking insights establish thought leadership."),
                TrendingTopic(title: "Community Engagement",    emoji: "🤝", momentum: .steady,    context: "Interactive content drives 2× more engagement."),
                TrendingTopic(title: "Educational Guides",      emoji: "📚", momentum: .evergreen, context: "How-to content has the longest lifespan."),
            ]
        }
    }
}
