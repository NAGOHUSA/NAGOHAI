import Foundation

// MARK: – API Errors

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case networkError(URLError)
    case serverError(statusCode: Int, message: String)
    case unauthorized
    case insufficientTokens
    case monthlyLimitExceeded

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .decodingError(let error):
            return "Could not parse server response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(_, let message):
            return message
        case .unauthorized:
            return "Your session has expired. Please sign in again."
        case .insufficientTokens:
            return "You don't have enough tokens. Please upgrade your plan."
        case .monthlyLimitExceeded:
            return "You've reached your monthly limit. Please upgrade your plan."
        }
    }
}

// MARK: – APIClient

final class APIClient {
    static let shared = APIClient()
    private init() {}

    private let baseURL = URL(string: "https://nagohai.gregoryhogan.workers.dev")!
    private let session = URLSession.shared

    // Injected token source; ViewModel/AuthManager sets this.
    var sessionToken: String?

    // MARK: – Generic request

    func request<T: Decodable>(
        _ endpoint: String,
        method: String = "GET",
        body: Encodable? = nil,
        authenticated: Bool = true
    ) async throws -> T {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw APIError.invalidURL
        }

        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if authenticated, let token = sessionToken {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body {
            req.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: req)
        } catch let urlError as URLError {
            throw APIError.networkError(urlError)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch http.statusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw APIError.decodingError(error)
            }
        case 401:
            throw APIError.unauthorized
        case 402:
            // Check body for specific error
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errorStr = json["error"] as? String {
                if errorStr.lowercased().contains("monthly") {
                    throw APIError.monthlyLimitExceeded
                }
                if errorStr.lowercased().contains("token") {
                    throw APIError.insufficientTokens
                }
            }
            throw APIError.insufficientTokens
        default:
            let message = (try? JSONSerialization.jsonObject(with: data) as? [String: Any])?["error"] as? String
                ?? HTTPURLResponse.localizedString(forStatusCode: http.statusCode)
            throw APIError.serverError(statusCode: http.statusCode, message: message)
        }
    }

    // MARK: – Convenience wrappers

    func get<T: Decodable>(_ endpoint: String, authenticated: Bool = true) async throws -> T {
        try await request(endpoint, method: "GET", authenticated: authenticated)
    }

    func post<T: Decodable>(_ endpoint: String, body: Encodable, authenticated: Bool = true) async throws -> T {
        try await request(endpoint, method: "POST", body: body, authenticated: authenticated)
    }

    // MARK: – Typed API calls

    func googleAuth(idToken: String) async throws -> AuthResponse {
        struct Body: Encodable { let id_token: String }
        return try await post("/v1/auth/google", body: Body(id_token: idToken), authenticated: false)
    }

    func guestAuth() async throws -> AuthResponse {
        struct Body: Encodable {}
        return try await post("/v1/auth/guest", body: Body(), authenticated: false)
    }

    func fetchBalance() async throws -> BalanceResponse {
        try await get("/v1/balance")
    }

    func sendChat(_ chatRequest: ChatRequest) async throws -> ChatResponse {
        try await post("/v1/chat", body: chatRequest)
    }

    func fetchTrending(industry: Industry) async throws -> TrendingResponse {
        try await get("/v1/trending?industry=\(industry.rawValue)")
    }

    func fetchAnalytics(period: AnalyticsPeriod) async throws -> AnalyticsData {
        try await get("/v1/analytics/dashboard?period=\(period.rawValue)")
    }

    func fetchQuote(name: String, service: String, scope: String, budget: String) async throws -> ChatResponse {
        struct Body: Encodable {
            let client_name: String
            let service_type: String
            let scope: String
            let budget: String
        }
        return try await post("/v1/quotes", body: Body(client_name: name, service_type: service, scope: scope, budget: budget))
    }

    func getSuggestions(content: String) async throws -> ChatResponse {
        struct Body: Encodable { let content: String }
        return try await post("/v1/suggestions", body: Body(content: content))
    }
}
