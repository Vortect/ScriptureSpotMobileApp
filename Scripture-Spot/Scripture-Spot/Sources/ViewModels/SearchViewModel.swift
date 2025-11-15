import Foundation
import SwiftUI

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var groups: [SearchGroup] = []
    @Published var isSearching = false

    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func submit(query: String) async {
        guard !query.isEmpty else { return }
        self.query = query
        isSearching = true
        defer { isSearching = false }
        do {
            groups = try await client.performSearch(request: .init(Query: query, Page: 1, PageSize: 25))
        } catch {
            groups = []
        }
    }

    func rebalance() {
        // Placeholder for advanced ranking work
        groups = groups.sorted { $0.entries.count > $1.entries.count }
    }
}
