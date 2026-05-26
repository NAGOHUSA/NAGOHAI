import Foundation

// MARK: - App Configuration
//
// Centralised constants matching the web worker configuration.
// To update credentials, edit only this file.

enum Config {
    // Cloudflare Worker base URL
    static let workerBaseURL = "https://nagohai.gregoryhogan.workers.dev"

    // Google OAuth web client ID (used for ASWebAuthenticationSession implicit flow).
    // For production iOS builds, create a dedicated iOS OAuth client ID in Google Cloud Console
    // and register the bundle ID us.nagoh.ai.NagohAI.
    static let googleClientID = "571680874030-4o2cr62ghese6d6r4e79m9gqj7vhsr9f.apps.googleusercontent.com"

    // Custom URL scheme registered in Info.plist for OAuth callbacks and payment success.
    static let urlScheme = "nagoh-ai"

    // Stripe direct payment link (fallback when the worker does not return a checkout URL).
    static let stripePaymentLink = "https://buy.stripe.com/4gM6oHdxyata0CVdIE1Fe06"

    // Stripe publishable key (used for future client-side Stripe Elements integration if needed).
    static let stripePublishableKey = "pk_live_51TK0JWGUbXtKf7F7FBt5ingZaPPj8oi6n7sk50AS4yWKkoISv6bJHXphJS5ygOX0QQScFuDUskZ6Uq0SCgwBVwnr00GVEiex2f"
}
