import Foundation
import Security

// MARK: – KeychainService

final class KeychainService {
    static let shared = KeychainService()
    private init() {}

    private let service = "com.nagoh.NAGOH-AI"

    // MARK: Save

    func save(_ value: String, forKey key: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.encodingFailed
        }

        let query: [CFString: Any] = [
            kSecClass:            kSecClassGenericPassword,
            kSecAttrService:      service,
            kSecAttrAccount:      key,
            kSecValueData:        data,
            kSecAttrAccessible:   kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
        ]

        // Delete existing item first
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status)
        }
    }

    // MARK: Load

    func load(forKey key: String) throws -> String {
        let query: [CFString: Any] = [
            kSecClass:            kSecClassGenericPassword,
            kSecAttrService:      service,
            kSecAttrAccount:      key,
            kSecReturnData:       true,
            kSecMatchLimit:       kSecMatchLimitOne,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            throw KeychainError.notFound
        }
        return value
    }

    // MARK: Delete

    func delete(forKey key: String) {
        let query: [CFString: Any] = [
            kSecClass:       kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
        ]
        SecItemDelete(query as CFDictionary)
    }

    // MARK: Helpers

    var sessionToken: String? {
        try? load(forKey: Keys.sessionToken)
    }

    func saveSession(_ session: Session) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(session)
        guard let json = String(data: data, encoding: .utf8) else {
            throw KeychainError.encodingFailed
        }
        try save(json, forKey: Keys.session)
        try save(session.token, forKey: Keys.sessionToken)
    }

    func loadSession() throws -> Session {
        let json = try load(forKey: Keys.session)
        guard let data = json.data(using: .utf8) else {
            throw KeychainError.encodingFailed
        }
        return try JSONDecoder().decode(Session.self, from: data)
    }

    func clearSession() {
        delete(forKey: Keys.session)
        delete(forKey: Keys.sessionToken)
    }

    enum Keys {
        static let sessionToken = "nagoh_session_token"
        static let session      = "nagoh_session"
    }
}

// MARK: – Error

enum KeychainError: LocalizedError {
    case saveFailed(OSStatus)
    case notFound
    case encodingFailed

    var errorDescription: String? {
        switch self {
        case .saveFailed(let status): return "Keychain save failed with status \(status)"
        case .notFound:               return "Item not found in Keychain"
        case .encodingFailed:         return "Failed to encode data"
        }
    }
}
