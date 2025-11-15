import Foundation
import SwiftUI

@MainActor
final class BibleNavigationViewModel: ObservableObject {
    @Published var versions: [BibleVersionSummary] = []
    @Published var books: [BibleBookInfo] = []
    @Published var chapters: [Int] = []
    @Published var verses: [BibleVerseVersion] = []
    @Published var verseRangeHTML: String?
    @Published var neighborChapters: [Int] = []
    @Published var isLoading = false
    @Published var selectedVersion: String

    private let client: APIClient
    private let configuration: APIConfiguration

    init(client: APIClient = .shared, configuration: APIConfiguration = .shared) {
        self.client = client
        self.configuration = configuration
        self.selectedVersion = configuration.defaultVersion
    }

    func loadVersions() async {
        guard versions.isEmpty else { return }
        do {
            versions = try await client.fetchBibleVersions()
        } catch {
            versions = []
        }
    }

    func loadBooks() async {
        guard books.isEmpty else { return }
        do {
            books = try await client.fetchBibleBooks()
        } catch {
            books = []
        }
    }

    func loadChapters(for bookSlug: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let raw = try await client.fetchBibleChapters(bookSlug: bookSlug)
            chapters = raw.compactMap { $0["chapterNumber"] }
            neighborChapters = chapters
        } catch {
            chapters = []
        }
    }

    func loadChapter(bookSlug: String, chapter: Int, version: String? = nil) async {
        isLoading = true
        defer { isLoading = false }
        let request = BibleVersesRequest(BookSlug: bookSlug, ChapterNumber: chapter)
        if let fetched = try? await client.fetchBibleVerses(request: request) {
            verses = fetched
        } else {
            verses = []
        }

        if let verseCount = verses.last?.verseNumber {
            let range = verseCount > 1 ? "1-\(verseCount)" : "1"
            let rangeRequest = BibleVerseRangeRequest(
                BookSlug: bookSlug,
                ChapterNumber: chapter,
                VerseRange: range,
                VersionName: (version ?? selectedVersion).uppercased()
            )
            verseRangeHTML = try? await client.fetchBibleVerseRange(request: rangeRequest).content
        }
    }
}

@MainActor
final class BibleChapterViewModel: ObservableObject {
    @Published var verses: [BibleVerseVersion] = []
    @Published var verseRangeHTML: String?
    @Published var isLoading = false

    private let client: APIClient
    private let version: String

    init(client: APIClient = .shared, version: String = APIConfiguration.shared.defaultVersion) {
        self.client = client
        self.version = version
    }

    func loadChapter(bookSlug: String, chapter: Int) async {
        isLoading = true
        defer { isLoading = false }
        let request = BibleVersesRequest(BookSlug: bookSlug, ChapterNumber: chapter)
        verses = (try? await client.fetchBibleVerses(request: request)) ?? []
        if let verseCount = verses.last?.verseNumber {
            let range = verseCount > 1 ? "1-\(verseCount)" : "1"
            let rangeRequest = BibleVerseRangeRequest(
                BookSlug: bookSlug,
                ChapterNumber: chapter,
                VerseRange: range,
                VersionName: version.uppercased()
            )
            verseRangeHTML = try? await client.fetchBibleVerseRange(request: rangeRequest).content
        }
    }
}
