import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var tokenBalance: Int = 0
    @Published var monthlyUsed: Int = 0
    @Published var monthlyLimit: Int = 1000
    @Published var plan: String = "free"
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let api = APIClient.shared

    func loadBalance() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let b = try await api.fetchBalance()
            tokenBalance = b.tokenBalance
            monthlyUsed = b.monthlyTokensUsed
            monthlyLimit = b.monthlyTokenLimit
            plan = b.plan
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
    }

    var usageProgress: Double {
        guard monthlyLimit > 0 else { return 0 }
        return min(Double(monthlyUsed) / Double(monthlyLimit), 1.0)
    }

    var planDisplayName: String {
        switch plan.lowercased() {
        case "free":         return "Free"
        case "starter":      return "Starter"
        case "professional": return "Professional"
        case "business":     return "Business"
        case "enterprise":   return "Enterprise"
        default:             return plan.capitalized
        }
    }

    var planEmoji: String {
        switch plan.lowercased() {
        case "free":         return "🌱"
        case "starter":      return "⚡"
        case "professional": return "🚀"
        case "business":     return "💼"
        case "enterprise":   return "🏢"
        default:             return "✨"
        }
    }
}
