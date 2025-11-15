import Foundation
import SwiftUI

@MainActor
final class StrongsViewModel: ObservableObject {
    @Published var entry: StrongsLexiconEntry?
    @Published var occurrences: [VerseReferenceOccurrence] = []
    @Published var highlightedTerms: [String] = []
    @Published var isBookmarked = false
    @Published var isLoading = false

    private let client: APIClient
    private let persistence: PersistenceStoreProtocol

    init(client: APIClient = .shared, persistence: PersistenceStoreProtocol = PersistenceStore.shared) {
        self.client = client
        self.persistence = persistence
    }

    func loadEntry(key: String, version: String = APIConfiguration.shared.defaultVersion) async {
        guard !key.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        async let entryTask = client.fetchLexiconEntry(key: key)
        async let referencesTask = client.fetchLexiconReferences(request: .init(StrongsKey: key, Version: version))
        entry = try? await entryTask
        occurrences = (try? await referencesTask) ?? []
        highlightedTerms = entry?.shortDefinition?.components(separatedBy: ",") ?? []
    }

    func bookmarkEntry(token: String) async {
        guard let entry else { return }
        let request = CreateBookmarkRequest(id: entry.id, type: .strongsConcordance, userId: "")
        do {
            try await client.createBookmark(request: request, token: token)
            isBookmarked = true
        } catch {}
    }

    func loadMoreOccurrences() async {
        // TODO: paginate occurrences when API adds support
    }
}
