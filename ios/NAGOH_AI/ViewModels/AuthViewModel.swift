import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var session: Session?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false

    private let api = APIClient.shared
    private let keychain = KeychainService.shared

    init() {
        restoreSession()
    }

    // MARK: – Session restore

    private func restoreSession() {
        guard let saved = try? keychain.loadSession() else { return }
        applySession(saved)
        Task { await validateSession() }
    }

    private func validateSession() async {
        do {
            let balance = try await api.fetchBalance()
            if var current = session {
                // Keep stored session but refresh balance
                let refreshed = Session(
                    token: current.token,
                    userId: current.userId,
                    email: current.email,
                    name: current.name,
                    picture: current.picture,
                    plan: balance.plan,
                    tokenBalance: balance.tokenBalance,
                    isGuest: current.isGuest
                )
                applySession(refreshed)
                try? keychain.saveSession(refreshed)
            }
        } catch APIError.unauthorized {
            logout()
        } catch {
            // Network error — keep cached session
        }
    }

    // MARK: – Google OAuth

    /// Called with the Google ID token string after successful GoogleSignIn SDK callback.
    func loginWithGoogle(idToken: String) async {
        await performAuth {
            let response = try await self.api.googleAuth(idToken: idToken)
            return self.makeSession(from: response, isGuest: false)
        }
    }

    // MARK: – Guest login

    func loginAsGuest() async {
        await performAuth {
            let response = try await self.api.guestAuth()
            return self.makeSession(from: response, isGuest: true)
        }
    }

    // MARK: – Logout

    func logout() {
        keychain.clearSession()
        api.sessionToken = nil
        session = nil
        isAuthenticated = false
    }

    // MARK: – Helpers

    private func performAuth(_ block: @escaping () async throws -> Session) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let newSession = try await block()
            applySession(newSession)
            try keychain.saveSession(newSession)
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
    }

    private func applySession(_ s: Session) {
        session = s
        api.sessionToken = s.token
        isAuthenticated = true
    }

    private func makeSession(from response: AuthResponse, isGuest: Bool) -> Session {
        Session(
            token: response.sessionToken,
            userId: response.user.id,
            email: response.user.email,
            name: response.user.name,
            picture: response.user.picture.flatMap(URL.init(string:)),
            plan: response.user.plan ?? "free",
            tokenBalance: response.tokenBalance,
            isGuest: isGuest
        )
    }
}
