import Foundation

// MARK: - User

struct AppUser: Codable, Equatable {
    let userId: String
    let name: String
    let email: String
    let picture: String?

    enum CodingKeys: String, CodingKey {
        case userId  = "user_id"
        case name, email, picture
    }
}

// MARK: - Auth / Balance responses

struct AuthResponse: Decodable {
    let sessionToken: String
    let user: AppUser
    let tokenBalance: Int
    let isNew: Bool?

    enum CodingKeys: String, CodingKey {
        case sessionToken  = "session_token"
        case user
        case tokenBalance  = "token_balance"
        case isNew         = "is_new"
    }
}

struct BalanceResponse: Decodable {
    let tokenBalance: Int
    enum CodingKeys: String, CodingKey { case tokenBalance = "token_balance" }
}

// MARK: - Chat

struct ChatMessage: Codable, Identifiable, Equatable {
    let id: UUID
    var role: String      // "user" | "assistant"
    var content: String
    var metadata: NagohMetadata?

    enum CodingKeys: String, CodingKey { case id, role, content, metadata }

    init(id: UUID = UUID(), role: String, content: String, metadata: NagohMetadata? = nil) {
        self.id = id; self.role = role; self.content = content; self.metadata = metadata
    }
}

struct NagohMetadata: Codable, Equatable {
    let tokensCharged: Int
    let tokensRemaining: Int
    enum CodingKeys: String, CodingKey {
        case tokensCharged   = "tokens_charged"
        case tokensRemaining = "tokens_remaining"
    }
}

struct ChatAPIResponse: Decodable {
    let message: MessagePayload
    let nagoh: NagohMetadata

    struct MessagePayload: Decodable { let content: String }
}

// MARK: - Session

struct ChatSession: Codable, Identifiable, Equatable {
    let id: UUID
    var title: String
    var messages: [ChatMessage]
    var createdAt: Date

    init(id: UUID = UUID(), title: String, messages: [ChatMessage] = [], createdAt: Date = Date()) {
        self.id = id; self.title = title; self.messages = messages; self.createdAt = createdAt
    }
}

// MARK: - AI Model

enum AIModel: String, CaseIterable, Identifiable {
    case chat     = "deepseek-chat"
    case reasoner = "deepseek-reasoner"

    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .chat:     return "NagohAI Chat (fast)"
        case .reasoner: return "NagohAI Reasoner (deep)"
        }
    }
}

// MARK: - Tone

enum ToneMode: String, CaseIterable, Identifiable {
    case friendly     = "friendly"
    case professional = "professional"
    case playful      = "playful"
    case concise      = "concise"

    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .friendly:     return "😊 Friendly & warm"
        case .professional: return "💼 Professional"
        case .playful:      return "🎉 Fun & playful"
        case .concise:      return "⚡ Short & snappy"
        }
    }
}

// MARK: - Connection

enum ConnectionStatus: Equatable {
    case idle, connecting, connected, error(String)

    var label: String {
        switch self {
        case .idle:             return "Not connected"
        case .connecting:       return "Connecting…"
        case .connected:        return "Connected ✓"
        case .error(let msg):   return msg
        }
    }

    var dotColor: String {
        switch self {
        case .connected:   return "sage"
        case .error:       return "rose"
        case .connecting:  return "gold"
        case .idle:        return "muted"
        }
    }
}

// MARK: - Pricing

struct PricingTier: Identifiable {
    let id: String
    let name: String
    let priceDisplay: String
    let tokens: String
    let period: String
    let tier: String
    let billing: String
    let priceCents: Int
    let isFeatured: Bool
    let saveBadge: String?
}

let PRICING_TIERS: [PricingTier] = [
    PricingTier(id: "starter_monthly",      name: "Starter",           priceDisplay: "$9",   tokens: "100,000",    period: "/mo", tier: "starter",       billing: "monthly", priceCents:  900, isFeatured: false, saveBadge: nil),
    PricingTier(id: "professional_monthly", name: "Professional",      priceDisplay: "$29",  tokens: "500,000",    period: "/mo", tier: "professional",  billing: "monthly", priceCents: 2900, isFeatured: true,  saveBadge: nil),
    PricingTier(id: "business_monthly",     name: "Business",          priceDisplay: "$99",  tokens: "2,000,000",  period: "/mo", tier: "business",      billing: "monthly", priceCents: 9900, isFeatured: false, saveBadge: nil),
    PricingTier(id: "starter_annual",       name: "Starter Annual",    priceDisplay: "$85",  tokens: "100,000",    period: "/yr", tier: "starter",       billing: "annual",  priceCents: 8500, isFeatured: false, saveBadge: "SAVE 6%"),
    PricingTier(id: "professional_annual",  name: "Pro Annual",        priceDisplay: "$275", tokens: "500,000",    period: "/yr", tier: "professional",  billing: "annual",  priceCents: 27500, isFeatured: false, saveBadge: "SAVE 21%"),
    PricingTier(id: "business_annual",      name: "Business Annual",   priceDisplay: "$940", tokens: "2,000,000",  period: "/yr", tier: "business",      billing: "annual",  priceCents: 94000, isFeatured: false, saveBadge: "SAVE 21%"),
]
