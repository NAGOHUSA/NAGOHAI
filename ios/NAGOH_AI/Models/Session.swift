import Foundation

struct Session: Codable, Equatable {
    let token: String
    let userId: String
    let email: String
    let name: String
    let picture: URL?
    let plan: String
    let tokenBalance: Int
    let isGuest: Bool

    enum CodingKeys: String, CodingKey {
        case token
        case userId   = "user_id"
        case email
        case name
        case picture
        case plan
        case tokenBalance = "token_balance"
        case isGuest  = "is_guest"
    }
}

// Response wrappers from the Worker API
struct AuthResponse: Decodable {
    let sessionToken: String
    let user: UserInfo
    let tokenBalance: Int

    enum CodingKeys: String, CodingKey {
        case sessionToken = "session_token"
        case user
        case tokenBalance = "token_balance"
    }
}

struct UserInfo: Decodable {
    let id: String
    let email: String
    let name: String
    let picture: String?
    let plan: String?

    enum CodingKeys: String, CodingKey {
        case id, email, name, picture, plan
    }
}

struct BalanceResponse: Decodable {
    let tokenBalance: Int
    let plan: String
    let monthlyTokensUsed: Int
    let monthlyTokenLimit: Int

    enum CodingKeys: String, CodingKey {
        case tokenBalance       = "token_balance"
        case plan
        case monthlyTokensUsed  = "monthly_tokens_used"
        case monthlyTokenLimit  = "monthly_token_limit"
    }
}
