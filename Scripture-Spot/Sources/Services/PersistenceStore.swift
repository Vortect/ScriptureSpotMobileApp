import Foundation

protocol PersistenceStoreProtocol {
    func lastVerse() -> (path: String, reference: String)?
    func saveLastVerse(path: String, reference: String)
    func lastPage() -> String?
    func saveLastPage(path: String)
    func preferredVersion() -> String
    func savePreferredVersion(_ version: String)
}

struct PersistenceStore: PersistenceStoreProtocol {
    static let shared = PersistenceStore()
    private let defaults = UserDefaults.standard

    private enum Keys {
        static let lastVersePath = "scripturespot.lastVerse.path"
        static let lastVerseReference = "scripturespot.lastVerse.reference"
        static let lastPagePath = "scripturespot.lastPage.path"
        static let preferredVersion = "scripturespot.version"
    }

    func lastVerse() -> (path: String, reference: String)? {
        guard let path = defaults.string(forKey: Keys.lastVersePath) else { return nil }
        let reference = defaults.string(forKey: Keys.lastVerseReference) ?? ""
        return (path, reference)
    }

    func saveLastVerse(path: String, reference: String) {
        defaults.set(path, forKey: Keys.lastVersePath)
        defaults.set(reference, forKey: Keys.lastVerseReference)
    }

    func lastPage() -> String? {
        defaults.string(forKey: Keys.lastPagePath)
    }

    func saveLastPage(path: String) {
        defaults.set(path, forKey: Keys.lastPagePath)
    }

    func preferredVersion() -> String {
        defaults.string(forKey: Keys.preferredVersion) ?? APIConfiguration.shared.defaultVersion
    }

    func savePreferredVersion(_ version: String) {
        defaults.set(version, forKey: Keys.preferredVersion)
    }
}
