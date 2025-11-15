import Foundation
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var verseOfTheDay: VerseOfTheDayResponse?
    @Published var lastVersePath: String?
    @Published var lastVerseReference: String?
    @Published var lastPagePath: String?
    @Published var isLoading = false

    private let apiClient: APIClient
    private let persistence: PersistenceStoreProtocol

    init(apiClient: APIClient = .shared, persistence: PersistenceStoreProtocol = PersistenceStore.shared) {
        self.apiClient = apiClient
        self.persistence = persistence
    }

    func loadVerseOfTheDay(version: String) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            verseOfTheDay = try await apiClient.fetchVerseOfTheDay(version: version)
        } catch {
            verseOfTheDay = nil
        }
    }

    func restoreLastActivity() {
        if let verse = persistence.lastVerse() {
            lastVersePath = verse.path
            lastVerseReference = verse.reference
        }
        lastPagePath = persistence.lastPage()
    }
}
