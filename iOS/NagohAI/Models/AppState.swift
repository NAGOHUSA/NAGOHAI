import Foundation
import Combine

// MARK: - AppState

@MainActor
final class AppState: ObservableObject {

    // MARK: Auth
    @Published var isAuthenticated = false
    @Published var sessionToken    = ""
    @Published var currentUser: AppUser?
    @Published var isGuest         = false

    // MARK: Balance / Status
    @Published var balance: Int           = 0
    @Published var connectionStatus: ConnectionStatus = .idle

    // MARK: Chat
    @Published var messages: [ChatMessage] = []
    @Published var sessions: [ChatSession] = []
    @Published var currentSession: ChatSession?
    @Published var isBusy = false
    @Published var sessionSpent = 0

    // MARK: Settings
    @Published var currentIndustry: Industry = .etsy
    @Published var selectedModel: AIModel    = .chat
    @Published var selectedTone: ToneMode    = .friendly

    // MARK: UI state
    @Published var showAuthSheet    = false
    @Published var showSidebar      = false
    @Published var showSettings     = false
    @Published var showUpgrade      = false
    @Published var successMessage: String? = nil

    // MARK: - Persistence keys
    private enum Keys {
        static let session   = "nagoh_session"
        static let sessions  = "nagoh_sessions"
        static let industry  = "nagoh_industry"
        static let model     = "nagoh_model"
        static let tone      = "nagoh_tone"
    }

    init() {
        loadPersistedSession()
        loadSettings()
        loadSessions()
    }

    // MARK: - Persistence

    private func loadPersistedSession() {
        if let data = UserDefaults.standard.data(forKey: Keys.session),
           let saved = try? JSONDecoder().decode(PersistedSession.self, from: data) {
            sessionToken    = saved.token
            currentUser     = saved.user
            balance         = saved.balance
            isAuthenticated = true
        }
    }

    func persistSession() {
        guard let user = currentUser else { return }
        let saved = PersistedSession(token: sessionToken, user: user, balance: balance)
        if let data = try? JSONEncoder().encode(saved) {
            UserDefaults.standard.set(data, forKey: Keys.session)
        }
    }

    private func loadSettings() {
        if let raw = UserDefaults.standard.string(forKey: Keys.industry),
           let ind = Industry(rawValue: raw) {
            currentIndustry = ind
        }
        if let raw = UserDefaults.standard.string(forKey: Keys.model),
           let m = AIModel(rawValue: raw) {
            selectedModel = m
        }
        if let raw = UserDefaults.standard.string(forKey: Keys.tone),
           let t = ToneMode(rawValue: raw) {
            selectedTone = t
        }
    }

    func saveSettings() {
        UserDefaults.standard.set(currentIndustry.rawValue, forKey: Keys.industry)
        UserDefaults.standard.set(selectedModel.rawValue,   forKey: Keys.model)
        UserDefaults.standard.set(selectedTone.rawValue,    forKey: Keys.tone)
    }

    func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: Keys.sessions),
           let saved = try? JSONDecoder().decode([ChatSession].self, from: data) {
            sessions = saved
        }
    }

    func saveSessions() {
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: Keys.sessions)
        }
    }

    // MARK: - Auth Actions

    func signInWithGoogle(idToken: String) async {
        connectionStatus = .connecting
        do {
            let resp = try await APIService.shared.authGoogle(idToken: idToken)
            applyAuthResponse(resp, guest: false)
            if resp.isNew == true {
                let first = currentUser?.name.components(separatedBy: " ").first ?? "there"
                addSystemMessage("Welcome to NAGOH AI, \(first)! 🎉 You've received 5,000 free tokens to get started. Choose your industry in the sidebar to see tailored prompts for your business.")
            }
        } catch {
            connectionStatus = .error(error.localizedDescription)
        }
    }

    func signInAsGuest() async {
        connectionStatus = .connecting
        do {
            let resp = try await APIService.shared.authGuest()
            applyAuthResponse(resp, guest: true)
        } catch {
            connectionStatus = .error(error.localizedDescription)
        }
    }

    private func applyAuthResponse(_ resp: AuthResponse, guest: Bool) {
        sessionToken    = resp.sessionToken
        currentUser     = resp.user
        balance         = resp.tokenBalance
        isGuest         = guest
        isAuthenticated = true
        connectionStatus = .connected
        persistSession()
    }

    func signOut() {
        sessionToken    = ""
        currentUser     = nil
        isGuest         = false
        isAuthenticated = false
        balance         = 0
        connectionStatus = .idle
        UserDefaults.standard.removeObject(forKey: Keys.session)
        messages        = []
        currentSession  = nil
        sessionSpent    = 0
    }

    // MARK: - Balance refresh

    func refreshBalance() async {
        guard !sessionToken.isEmpty else { return }
        do {
            let resp = try await APIService.shared.getBalance(token: sessionToken)
            balance = resp.tokenBalance
            persistSession()
            connectionStatus = .connected
        } catch APIError.unauthorized {
            signOut()
        } catch {
            connectionStatus = .error("Offline")
        }
    }

    // MARK: - Chat

    func sendMessage(_ text: String) async {
        guard !text.isEmpty, !isBusy else { return }
        isBusy = true

        let userMsg = ChatMessage(role: "user", content: text)
        messages.append(userMsg)

        do {
            let resp = try await APIService.shared.sendChat(
                messages: messages,
                system: systemPrompt(),
                model: selectedModel.rawValue,
                token: sessionToken
            )
            let aiMsg = ChatMessage(
                role: "assistant",
                content: resp.message.content,
                metadata: resp.nagoh
            )
            messages.append(aiMsg)
            balance       = resp.nagoh.tokensRemaining
            sessionSpent += resp.nagoh.tokensCharged
            persistSession()
            saveCurrentSession(firstMsg: text)
        } catch APIError.outOfTokens {
            messages.removeLast()
            addSystemMessage("⚠️ You're out of tokens! Tap 'Upgrade' to buy more.")
            showUpgrade = true
        } catch APIError.unauthorized {
            messages.removeLast()
            signOut()
        } catch {
            messages.removeLast()
            addSystemMessage("⚠️ \(error.localizedDescription)")
        }
        isBusy = false
    }

    private func addSystemMessage(_ text: String) {
        messages.append(ChatMessage(role: "assistant", content: text))
    }

    // MARK: - System Prompt

    func systemPrompt() -> String {
        let conf = INDUSTRIES[currentIndustry]
        return conf?.tonePrompts[selectedTone.rawValue]
            ?? INDUSTRIES[.general]?.tonePrompts["friendly"]
            ?? "You are NAGOH AI, a helpful small business assistant."
    }

    // MARK: - Session management

    func saveCurrentSession(firstMsg: String) {
        if currentSession == nil {
            let newSession = ChatSession(title: String(firstMsg.prefix(45)), messages: messages)
            sessions.insert(newSession, at: 0)
            currentSession = sessions.first
            if sessions.count > 50 { sessions = Array(sessions.prefix(50)) }
        } else {
            if let idx = sessions.firstIndex(where: { $0.id == currentSession?.id }) {
                sessions[idx].messages = messages
                currentSession = sessions[idx]
            }
        }
        saveSessions()
    }

    func loadSession(_ session: ChatSession) {
        currentSession = session
        messages       = session.messages
        sessionSpent   = session.messages.compactMap(\.metadata?.tokensCharged).reduce(0, +)
    }

    func newChat() {
        currentSession = nil
        messages       = []
        sessionSpent   = 0
    }

    func clearAllSessions() {
        sessions       = []
        currentSession = nil
        messages       = []
        sessionSpent   = 0
        saveSessions()
    }

    // MARK: - Suggestions

    func suggestions(for text: String) -> [String] {
        let lower = text.lowercased()
        if lower.contains("list") || lower.contains("product") || lower.contains("service") {
            return ["Make it shorter", "Add more detail", "Write a second version", "Make it more professional"]
        }
        if lower.contains("social") || lower.contains("post") || lower.contains("caption") {
            return ["Give me more options", "Make it shorter", "Add emojis", "Write a different tone"]
        }
        return ["Tell me more", "Give me another version", "Make it shorter", "Can you explain?"]
    }

    // MARK: - Notifications

    func showSuccess(_ msg: String) {
        successMessage = msg
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.successMessage = nil
        }
    }
}

// MARK: - PersistedSession

private struct PersistedSession: Codable {
    let token: String
    let user: AppUser
    let balance: Int
}
