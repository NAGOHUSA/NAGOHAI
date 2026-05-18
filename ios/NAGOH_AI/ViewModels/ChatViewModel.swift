import Foundation
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var selectedContentType: ContentType = .chat
    @Published var selectedIndustry: Industry = .etsy
    @Published var tokenBalance: Int = 0
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Injected from outside (AuthViewModel.session)
    var sessionToken: String? {
        get { APIClient.shared.sessionToken }
    }

    private let api = APIClient.shared

    // Pending topic to pre-fill from Trending / Templates screen
    var pendingPrompt: String? {
        didSet {
            if let p = pendingPrompt {
                inputText = p
                pendingPrompt = nil
            }
        }
    }

    // MARK: – Send message

    func send() async {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !isLoading else { return }

        inputText = ""
        errorMessage = nil

        let userMessage = ChatMessage(role: .user, content: text, contentType: selectedContentType)
        messages.append(userMessage)

        let loadingMessage = ChatMessage(role: .assistant, content: "", isLoading: true)
        messages.append(loadingMessage)
        isLoading = true

        defer { isLoading = false }

        do {
            let history = messages
                .filter { !$0.isLoading }
                .map { ChatRequestMessage(role: $0.role.rawValue, content: $0.content) }

            let request = ChatRequest(
                messages: history,
                system: selectedIndustry.systemPrompt,
                model: "deepseek-chat",
                maxTokens: 2048,
                temperature: 0.75,
                contentType: selectedContentType.rawValue
            )

            let response = try await api.sendChat(request)

            // Replace loading bubble
            if let idx = messages.lastIndex(where: { $0.isLoading }) {
                messages[idx] = ChatMessage(
                    role: .assistant,
                    content: response.content,
                    contentType: selectedContentType,
                    tokensUsed: response.tokensUsed
                )
            }

            if let balance = response.remainingBalance {
                tokenBalance = balance
            }

        } catch {
            // Remove loading bubble
            messages.removeAll { $0.isLoading }
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
    }

    // MARK: – Quick starter tapped

    func useQuickStarter(_ starter: QuickStarter) {
        inputText = starter.prompt
    }

    // MARK: – Clear conversation

    func clearMessages() {
        messages.removeAll()
    }

    // MARK: – Refresh balance

    func refreshBalance() async {
        do {
            let b = try await api.fetchBalance()
            tokenBalance = b.tokenBalance
        } catch { /* silent */ }
    }
}
