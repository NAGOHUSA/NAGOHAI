import Foundation

struct ChatMessage: Identifiable, Codable, Equatable {
    var id: UUID
    let role: MessageRole
    let content: String
    let contentType: ContentType?
    let timestamp: Date
    var tokensUsed: Int?
    var isLoading: Bool

    init(
        id: UUID = UUID(),
        role: MessageRole,
        content: String,
        contentType: ContentType? = nil,
        timestamp: Date = Date(),
        tokensUsed: Int? = nil,
        isLoading: Bool = false
    ) {
        self.id = id
        self.role = role
        self.content = content
        self.contentType = contentType
        self.timestamp = timestamp
        self.tokensUsed = tokensUsed
        self.isLoading = isLoading
    }

    enum CodingKeys: String, CodingKey {
        case id, role, content, contentType, timestamp, tokensUsed, isLoading
    }
}

enum MessageRole: String, Codable {
    case user
    case assistant
    case system
}

enum ContentType: String, Codable, CaseIterable, Identifiable {
    case chat
    case social
    case email
    case quote
    case blog

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .chat:    return "💬 Chat"
        case .social:  return "📱 Social"
        case .email:   return "📧 Email"
        case .quote:   return "💰 Quote"
        case .blog:    return "📝 Blog"
        }
    }

    var emoji: String {
        switch self {
        case .chat:    return "💬"
        case .social:  return "📱"
        case .email:   return "📧"
        case .quote:   return "💰"
        case .blog:    return "📝"
        }
    }
}

struct ChatRequest: Encodable {
    let messages: [ChatRequestMessage]
    let system: String
    let model: String
    let maxTokens: Int
    let temperature: Double
    let contentType: String

    enum CodingKeys: String, CodingKey {
        case messages, system, model, temperature
        case maxTokens   = "max_tokens"
        case contentType = "content_type"
    }
}

struct ChatRequestMessage: Encodable {
    let role: String
    let content: String
}

struct ChatResponse: Decodable {
    let content: String
    let tokensUsed: Int?
    let remainingBalance: Int?

    enum CodingKeys: String, CodingKey {
        case content
        case tokensUsed       = "tokens_used"
        case remainingBalance = "remaining_balance"
    }
}
