import Foundation
import SwiftUI
import Combine

@MainActor
final class ReaderViewModel: ObservableObject {
    @Published var chapter: ReaderChapterPayload?
    @Published var isLoading = false
    @Published var error: APIError?

    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func loadChapter(author: String, book: String, chapter: Int) async {
        isLoading = true
        defer { isLoading = false }
        do {
            self.chapter = try await client.fetchReaderChapter(author: author, book: book, chapter: chapter)
        } catch let apiError as APIError {
            error = apiError
        } catch {
            error = .unknown(error)
        }
    }
}
