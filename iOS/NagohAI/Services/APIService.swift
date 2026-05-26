import Foundation
import Combine

// MARK: - Errors

enum APIError: LocalizedError {
    case badResponse(Int, String?)
    case outOfTokens
    case unauthorized
    case networkError(Error)
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .badResponse(let code, let msg): return msg ?? "Server error (\(code))"
        case .outOfTokens:     return "You're out of tokens! Upgrade to continue."
        case .unauthorized:    return "Session expired. Please sign in again."
        case .networkError(let e): return "Network error: \(e.localizedDescription)"
        case .decodingError(let e): return "Unexpected response: \(e.localizedDescription)"
        }
    }
}

// MARK: - APIService

actor APIService {
    static let shared = APIService()

    // Worker base URL — see Config.swift
    private let base = Config.workerBaseURL

    private func request<T: Decodable>(
        _ path: String,
        method: String = "GET",
        body: Encodable? = nil,
        token: String? = nil
    ) async throws -> T {
        guard let url = URL(string: base + path) else {
            throw URLError(.badURL)
        }
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token { req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") }
        if let body  { req.httpBody = try JSONEncoder().encode(body) }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: req)
        } catch {
            throw APIError.networkError(error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.networkError(URLError(.badServerResponse))
        }

        if http.statusCode == 402 { throw APIError.outOfTokens }
        if http.statusCode == 401 { throw APIError.unauthorized }

        if !(200..<300).contains(http.statusCode) {
            let msg = (try? JSONDecoder().decode(ErrorResponse.self, from: data))?.error
            throw APIError.badResponse(http.statusCode, msg)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    // MARK: - Auth

    func authGoogle(idToken: String) async throws -> AuthResponse {
        struct Body: Encodable { let id_token: String }
        return try await request("/v1/auth/google", method: "POST", body: Body(id_token: idToken))
    }

    func authGuest() async throws -> AuthResponse {
        struct Empty: Encodable {}
        return try await request("/v1/auth/guest", method: "POST", body: Empty())
    }

    // MARK: - Balance

    func getBalance(token: String) async throws -> BalanceResponse {
        return try await request("/v1/balance", token: token)
    }

    // MARK: - Chat

    func sendChat(
        messages: [ChatMessage],
        system: String,
        model: String,
        maxTokens: Int = 2048,
        temperature: Double = 0.75,
        token: String
    ) async throws -> ChatAPIResponse {
        struct Body: Encodable {
            let messages: [MsgPayload]
            let system: String
            let model: String
            let max_tokens: Int
            let temperature: Double
        }
        struct MsgPayload: Encodable {
            let role: String
            let content: String
        }
        let payload = messages.map { MsgPayload(role: $0.role, content: $0.content) }
        return try await request(
            "/v1/chat",
            method: "POST",
            body: Body(messages: payload, system: system, model: model, max_tokens: maxTokens, temperature: temperature),
            token: token
        )
    }

    // MARK: - Checkout

    func createCheckout(
        tier: String,
        billing: String,
        priceCents: Int,
        userId: String,
        userEmail: String,
        token: String
    ) async throws -> CheckoutResponse {
        struct Body: Encodable {
            let tier: String
            let billing_period: String
            let price_cents: Int
            let user_id: String
            let user_email: String
        }
        return try await request(
            "/v1/checkout/session",
            method: "POST",
            body: Body(tier: tier, billing_period: billing, price_cents: priceCents, user_id: userId, user_email: userEmail),
            token: token
        )
    }
}

// MARK: - Additional response types

struct CheckoutResponse: Decodable {
    let checkoutUrl: String?
    let clientSecret: String?
    enum CodingKeys: String, CodingKey {
        case checkoutUrl  = "checkout_url"
        case clientSecret = "client_secret"
    }
}

private struct ErrorResponse: Decodable {
    let error: String?
}
