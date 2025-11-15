import Combine
import Foundation

@MainActor
final class SessionManager: ObservableObject {
    static let shared = SessionManager()

    @Published private(set) var currentToken: String?
    @Published private(set) var isAuthenticated = false

    private init() {}

    func loadPersistedSession() {
        if let token = KeychainWrapper.shared.retrieveToken() {
            currentToken = token
            isAuthenticated = true
        }
    }

    func handleCallback(url: URL) {
        // TODO: Exchange Clerk callback for JWT once backend flow is finalized
        // For now we simply simulate a successful sign in to unblock development
        let simulatedToken = "local-dev-token"
        currentToken = simulatedToken
        isAuthenticated = true
        KeychainWrapper.shared.store(token: simulatedToken)
    }

    func signOut() {
        currentToken = nil
        isAuthenticated = false
        KeychainWrapper.shared.clear()
    }
}

// MARK: - Lightweight keychain shim
final class KeychainWrapper {
    static let shared = KeychainWrapper()
    private let tokenKey = "scripture.spot.token"

    func store(token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }

    func retrieveToken() -> String? {
        UserDefaults.standard.string(forKey: tokenKey)
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
