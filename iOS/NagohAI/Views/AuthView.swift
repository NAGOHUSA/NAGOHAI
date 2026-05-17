import SwiftUI
import AuthenticationServices

// MARK: - AuthView

struct AuthView: View {
    @EnvironmentObject var appState: AppState
    @State private var isGoogleLoading = false
    @State private var isGuestLoading  = false
    @State private var errorText       = ""

    var body: some View {
        ZStack {
            NagohTheme.deep.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Hero
                    VStack(spacing: 6) {
                        Text("NAGOH \u{200B}")
                            .font(.custom("Georgia-Bold", size: 38))
                            .foregroundColor(.white)
                        + Text("AI")
                            .font(.custom("Georgia-BoldItalic", size: 38))
                            .foregroundColor(NagohTheme.gold)

                        Text("Your Small Business Assistant")
                            .font(NagohTheme.sans(12, weight: .regular))
                            .foregroundColor(.white.opacity(0.5))
                            .kerning(1.2)
                            .textCase(.uppercase)
                    }
                    .padding(.top, 56)
                    .padding(.bottom, 32)

                    // Card
                    VStack(spacing: 0) {
                        VStack(alignment: .center, spacing: 8) {
                            Text("Welcome! 👋")
                                .font(.custom("Georgia", size: 22))
                                .foregroundColor(NagohTheme.ink)

                            Text("Sign in with Google to get started.\nNew users receive 5,000 free tokens instantly.")
                                .font(NagohTheme.sans(13))
                                .foregroundColor(NagohTheme.dim)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                        .padding(.top, 24)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)

                        // Value props
                        VStack(spacing: 8) {
                            valueProp(icon: "✍️", text: "Craft professional messages instantly")
                            valueProp(icon: "📱", text: "Generate marketing content for your business")
                            valueProp(icon: "💌", text: "Reply to customers with confidence")
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)

                        Divider().background(NagohTheme.border)

                        // Buttons
                        VStack(spacing: 12) {
                            // Google sign-in
                            Button(action: startGoogleSignIn) {
                                HStack(spacing: 10) {
                                    if isGoogleLoading {
                                        ProgressView()
                                            .progressViewStyle(.circular)
                                            .scaleEffect(0.85)
                                    } else {
                                        googleLogo
                                    }
                                    Text(isGoogleLoading ? "Signing in…" : "Continue with Google")
                                        .font(NagohTheme.sans(15, weight: .medium))
                                        .foregroundColor(NagohTheme.ink)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(NagohTheme.border2, lineWidth: 1.5)
                                )
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 1)
                            }
                            .disabled(isGoogleLoading || isGuestLoading)

                            // Divider
                            HStack {
                                Rectangle().frame(height: 1).foregroundColor(NagohTheme.border)
                                Text("or")
                                    .font(NagohTheme.sans(11))
                                    .foregroundColor(NagohTheme.muted)
                                    .kerning(0.8)
                                Rectangle().frame(height: 1).foregroundColor(NagohTheme.border)
                            }

                            // Guest
                            Button(action: continueAsGuest) {
                                HStack(spacing: 8) {
                                    if isGuestLoading {
                                        ProgressView().progressViewStyle(.circular).scaleEffect(0.85)
                                    } else {
                                        Text("👤")
                                    }
                                    Text(isGuestLoading ? "Loading…" : "Continue as Guest")
                                        .font(NagohTheme.sans(14, weight: .medium))
                                        .foregroundColor(NagohTheme.dim)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(NagohTheme.border2, lineWidth: 1.5)
                                )
                                .cornerRadius(12)
                            }
                            .disabled(isGoogleLoading || isGuestLoading)

                            Text("No account needed — get 1,000 free tokens.\nTokens don't carry over between visits.")
                                .font(NagohTheme.sans(11))
                                .foregroundColor(NagohTheme.muted)
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)

                            if !errorText.isEmpty {
                                Text(errorText)
                                    .font(NagohTheme.sans(12))
                                    .foregroundColor(NagohTheme.rose)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(24)
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: 8)
                    .padding(.horizontal, 24)

                    // Footer
                    Text("ai.nagoh.us  ·  Your data is private and never shared.")
                        .font(NagohTheme.sans(10))
                        .foregroundColor(.white.opacity(0.3))
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                        .padding(.horizontal, 24)
                }
            }
        }
    }

    // MARK: - Sub-views

    @ViewBuilder
    private func valueProp(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Text(icon).font(.system(size: 18))
            Text(text)
                .font(NagohTheme.sans(13, weight: .medium))
                .foregroundColor(NagohTheme.ink)
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(NagohTheme.parchment)
        .cornerRadius(10)
    }

    private var googleLogo: some View {
        // Simplified Google "G" using system colors
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 18, height: 18)
            Text("G")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(Color(hex: "4285F4"))
        }
    }

    // MARK: - Actions

    private func startGoogleSignIn() {
        isGoogleLoading = true
        errorText = ""

        // Google OAuth2 implicit flow via ASWebAuthenticationSession
        // NOTE: The redirect URI "nagoh-ai://oauth2redirect" must be registered in
        // Google Cloud Console for client ID:
        // 571680874030-4o2cr62ghese6d6r4e79m9gqj7vhsr9f.apps.googleusercontent.com
        // An iOS-specific OAuth client ID is recommended for production.

        let clientID = "571680874030-4o2cr62ghese6d6r4e79m9gqj7vhsr9f.apps.googleusercontent.com"
        let redirectURI = "nagoh-ai://oauth2redirect"
        let nonce = UUID().uuidString.replacingOccurrences(of: "-", with: "")

        var components = URLComponents(string: "https://accounts.google.com/o/oauth2/v2/auth")!
        components.queryItems = [
            URLQueryItem(name: "client_id",      value: clientID),
            URLQueryItem(name: "redirect_uri",   value: redirectURI),
            URLQueryItem(name: "response_type",  value: "id_token"),
            URLQueryItem(name: "scope",          value: "openid email profile"),
            URLQueryItem(name: "nonce",          value: nonce),
        ]
        guard let authURL = components.url else {
            isGoogleLoading = false
            errorText = "Failed to build authentication URL."
            return
        }

        // Use ASWebAuthenticationSession to handle the OAuth flow
        let session = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: "nagoh-ai"
        ) { callbackURL, error in
            Task { @MainActor in
                defer { isGoogleLoading = false }
                if let error = error as? ASWebAuthenticationSessionError,
                   error.code == .canceledLogin {
                    errorText = "Sign-in cancelled."
                    return
                }
                if let error {
                    errorText = error.localizedDescription
                    return
                }
                guard let callbackURL,
                      let fragment = callbackURL.fragment else {
                    errorText = "No token in response."
                    return
                }
                // Parse id_token from URL fragment
                var idToken: String?
                for param in fragment.components(separatedBy: "&") {
                    let kv = param.components(separatedBy: "=")
                    if kv.count == 2, kv[0] == "id_token" {
                        idToken = kv[1]
                    }
                }
                guard let token = idToken else {
                    errorText = "id_token not found in response."
                    return
                }
                await appState.signInWithGoogle(idToken: token)
            }
        }
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first
        let context = AuthPresentationContext(window: window)
        session.presentationContextProvider = context
        session.prefersEphemeralWebBrowserSession = false
        // Retain context for the duration of the session
        objc_setAssociatedObject(session, &AssociatedKeys.context, context, .OBJC_ASSOCIATION_RETAIN)
        session.start()
    }

    private func continueAsGuest() {
        isGuestLoading = true
        errorText = ""
        Task {
            await appState.signInAsGuest()
            isGuestLoading = false
        }
    }
}

// MARK: - Preview

#Preview {
    AuthView().environmentObject(AppState())
}

// MARK: - Presentation context helper

private enum AssociatedKeys { static var context = "AuthPresentationContext" }

private class AuthPresentationContext: NSObject, ASWebAuthenticationPresentationContextProviding {
    weak var window: UIWindow?
    init(window: UIWindow?) { self.window = window }
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        window ?? UIWindow()
    }
}
