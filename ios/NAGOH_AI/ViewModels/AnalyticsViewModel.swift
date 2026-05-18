import Foundation
import Combine

@MainActor
final class AnalyticsViewModel: ObservableObject {
    @Published var data: AnalyticsData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isDemoMode: Bool {
        didSet {
            UserDefaults.standard.set(isDemoMode, forKey: Keys.demoMode)
            Task { await loadData() }
        }
    }
    @Published var period: AnalyticsPeriod = .week {
        didSet {
            if !isDemoMode {
                Task { await loadData() }
            }
        }
    }

    private let api = APIClient.shared
    private enum Keys { static let demoMode = "nagoh_analytics_demo" }

    init() {
        isDemoMode = UserDefaults.standard.bool(forKey: Keys.demoMode)
    }

    func loadData() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        if isDemoMode {
            // Simulate a slight delay for realism
            try? await Task.sleep(nanoseconds: 300_000_000)
            data = AnalyticsData.demo
            return
        }

        do {
            data = try await api.fetchAnalytics(period: period)
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            // Fall back to demo data so the screen isn't empty
            if data == nil {
                data = AnalyticsData.demo
            }
        }
    }
}
