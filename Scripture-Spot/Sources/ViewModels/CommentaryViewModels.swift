import Foundation
import SwiftUI
import Combine

@MainActor
final class CommentatorsViewModel: ObservableObject {
    @Published var authors: [Author] = []
    @Published var error: APIError?

    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func loadAuthors() async {
        do {
            authors = try await client.fetchAuthors()
        } catch let apiError as APIError {
            error = apiError
        } catch {
            error = .unknown(error)
        }
    }
}

@MainActor
final class AuthorDetailViewModel: ObservableObject {
    @Published var author: Author?
    @Published var availableBooks: [BibleBookInfo] = []
    @Published var bookAvailability: [String: Bool] = [:]
    @Published var isLoading = false

    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func hydrate(authorSlug: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let authors = try await client.fetchAuthors()
            author = authors.first(where: { $0.slug == authorSlug })
            availableBooks = try await client.fetchBibleBooks()
        } catch {
            availableBooks = []
        }
    }

    func loadAvailability(for authorSlug: String, books: [String]) async {
        let request = CommentaryAvailabilityRequest(AuthorSlug: authorSlug, BookSlugs: books)
        bookAvailability = (try? await client.fetchCommentaryAvailability(request: request)) ?? [:]
    }
}

@MainActor
final class AuthorChapterViewModel: ObservableObject {
    @Published var chapters: [Int] = []
    @Published var chapterAvailability: [Int: Bool] = [:]
    @Published var featuredCommentaries: [Commentary] = []

    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func loadChapters(bookSlug: String) async {
        let raw = try? await client.fetchBibleChapters(bookSlug: bookSlug)
        chapters = raw?.compactMap { $0["chapterNumber"] } ?? []
    }

    func loadChapterAvailability(authorSlug: String, bookSlug: String, chapterNumbers: [Int]) async {
        let request = ChapterAvailabilityRequest(AuthorSlug: authorSlug, BookSlug: bookSlug, ChapterNumbers: chapterNumbers)
        let response = try? await client.fetchChapterAvailability(request: request)
        chapterAvailability = response?.reduce(into: [:]) { partialResult, entry in
            if let chapter = Int(entry.key) { partialResult[chapter] = entry.value }
        } ?? [:]
    }

    func loadInitialCommentaries(authorSlug: String, bookSlug: String, chapter: Int, version: String) async {
        let request = CommentaryByChapterRequest(AuthorSlug: authorSlug, BookSlug: bookSlug, ChapterNumber: chapter, RequestType: "Chapter", VersionName: version)
        featuredCommentaries = (try? await client.fetchCommentaries(byChapter: request)) ?? []
    }
}

@MainActor
final class ChapterCommentaryViewModel: ObservableObject {
    @Published var groupedCommentaries: [CommentaryGroup] = []
    @Published var selectedVersion: String

    private let client: APIClient

    init(client: APIClient = .shared, defaultVersion: String = APIConfiguration.shared.defaultVersion) {
        self.client = client
        self.selectedVersion = defaultVersion
    }

    func loadChapter(authorSlug: String, bookSlug: String, chapter: Int) async {
        let request = CommentaryByChapterRequest(AuthorSlug: authorSlug, BookSlug: bookSlug, ChapterNumber: chapter, RequestType: "Chapter", VersionName: selectedVersion.uppercased())
        let commentaries = (try? await client.fetchCommentaries(byChapter: request)) ?? []
        groupedCommentaries = Dictionary(grouping: commentaries) { commentary in
            commentary.bibleVerseReference?.startVerse?.verseNumber ?? 0
        }.map { key, value in
            CommentaryGroup(verse: key, commentaries: value)
        }.sorted { $0.verse < $1.verse }
    }

    func changeVersion(_ version: String) {
        selectedVersion = version
    }
}
