import SwiftUI

@main
struct NagohAIApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.light)   // match website's light warm theme
                .tint(Color(hex: "2a9d8f"))     // NagohTheme.teal as accent
                .onOpenURL { url in
                    // Handle deep-link callbacks (e.g., Google OAuth redirect)
                    handleDeepLink(url)
                }
        }
    }

    private func handleDeepLink(_ url: URL) {
        // Google OAuth callback is handled by ASWebAuthenticationSession internally.
        // Payment success deep link: nagoh-ai://payment?status=success
        guard url.scheme == "nagoh-ai",
              url.host == "payment",
              let comps = URLComponents(url: url, resolvingAgainstBaseURL: false),
              comps.queryItems?.first(where: { $0.name == "status" })?.value == "success"
        else { return }

        Task {
            await appState.refreshBalance()
            appState.showSuccess("✅ Purchase successful! Your tokens have been added.")
        }
    }
}
