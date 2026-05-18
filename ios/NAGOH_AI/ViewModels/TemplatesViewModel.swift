import Foundation

@MainActor
final class TemplatesViewModel: ObservableObject {
    @Published var selectedIndustry: Industry = .etsy
    @Published var templates: [AppTemplate] = []
    @Published var strategyPrompts: [StrategyPrompt] = []
    @Published var copiedId: String?
    @Published var quoteResult: String?
    @Published var suggestionsResult: String?
    @Published var isLoadingQuote = false
    @Published var isLoadingSuggestions = false
    @Published var errorMessage: String?

    private let api = APIClient.shared

    init() {
        loadTemplates()
    }

    func loadTemplates() {
        templates = selectedIndustry.templates
        strategyPrompts = selectedIndustry.strategyPrompts
    }

    func selectIndustry(_ industry: Industry) {
        selectedIndustry = industry
        loadTemplates()
    }

    func copy(_ content: String, id: String) {
        UIPasteboard.general.string = content
        copiedId = id
        // Reset after 2s
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            if copiedId == id { copiedId = nil }
        }
    }

    func generateQuote(name: String, service: String, scope: String, budget: String) async {
        guard !name.isEmpty, !service.isEmpty else {
            errorMessage = "Please fill in at least client name and service type."
            return
        }
        isLoadingQuote = true
        errorMessage = nil
        defer { isLoadingQuote = false }
        do {
            let r = try await api.fetchQuote(name: name, service: service, scope: scope, budget: budget)
            quoteResult = r.content
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
    }

    func getSuggestions(content: String) async {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please paste some content first."
            return
        }
        isLoadingSuggestions = true
        errorMessage = nil
        defer { isLoadingSuggestions = false }
        do {
            let r = try await api.getSuggestions(content: content)
            suggestionsResult = r.content
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
    }
}
