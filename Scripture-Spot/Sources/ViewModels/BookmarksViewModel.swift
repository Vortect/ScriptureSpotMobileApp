import Foundation
import SwiftUI
import Combine

@MainActor
final class BookmarksViewModel: ObservableObject {
    @Published var groups: [BookmarkGroup] = []
    @Published var filters: BookmarkFilters = .default
    @Published var isLoading = false
    @Published var error: APIError?

    private let client: APIClient
    private var lastToken: String?

    init(client: APIClient = .shared) {
        self.client = client
    }

    func loadBookmarks(token: String) async {
        guard !token.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await client.fetchBookmarks(token: token)
            lastToken = token
            groups = group(response.bookmarks)
        } catch let apiError as APIError {
            error = apiError
        } catch let underlyingError {
            let unknownErr = APIError.unknown(underlyingError)
            self.error = unknownErr
        }
    }

    func apply(filters: BookmarkFilters) async {
        self.filters = filters
        guard let token = lastToken else { return }
        await loadBookmarks(token: token)
    }

    func deleteBookmark(_ id: String) async {
        guard let token = lastToken else { return }
        do {
            try await client.deleteBookmark(request: .init(id: id, userId: ""), token: token)
            await loadBookmarks(token: token)
        } catch {}
    }

    private func group(_ bookmarks: [Bookmark]) -> [BookmarkGroup] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let grouped = Dictionary(grouping: bookmarks) { bookmark -> String in
            formatter.string(from: bookmark.createdAt)
        }
        return grouped.map { key, value in
            let displays = value.map { bookmark -> BookmarkDisplay in
                BookmarkDisplay(
                    bookmark: bookmark,
                    formattedReference: bookmark.reference,
                    formattedDate: formatter.string(from: bookmark.createdAt),
                    displayTags: bookmark.tags,
                    excerpt: bookmark.commentary?.previewContent,
                    monthYear: key,
                    hymnText: nil,
                    sermonText: nil,
                    highlightedText: bookmark.highlights?.first?.value,
                    bookTitle: bookmark.bookOverview?.bibleBook?.name,
                    bookChapter: bookmark.bookOverview?.bookStructure
                )
            }
            return BookmarkGroup(monthYear: key, displayName: key, bookmarks: displays, count: displays.count)
        }.sorted { $0.monthYear < $1.monthYear }
    }
}
