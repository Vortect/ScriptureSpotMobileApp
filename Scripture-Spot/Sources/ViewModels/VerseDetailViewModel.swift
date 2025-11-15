import Foundation
import SwiftUI
import Combine

@MainActor
final class VerseDetailViewModel: ObservableObject {
    @Published var verseVersion: BibleVerseVersion?
    @Published var bookOverview: BibleBookOverview?
    @Published var verseTakeaways: [VerseTakeaway] = []
    @Published var commentaryCount: Int = 0
    @Published var crossReferences: [CrossReferenceKeyword] = []
    @Published var interlinearWords: [InterlinearWord] = []
    @Published var error: APIError?
    @Published var isLoading = false

    private let client: APIClient
    private let analytics: AnalyticsService

    init(client: APIClient = .shared, analytics: AnalyticsService = AnalyticsManager.shared) {
        self.client = client
        self.analytics = analytics
    }

    func loadVerse(bookSlug: String, chapter: Int, verse: Int, version: String) async {
        isLoading = true
        defer { isLoading = false }
        analytics.trackVerseOpen(book: bookSlug, chapter: chapter, verse: verse)
        do {
            async let versionTask = client.fetchBibleVerseVersion(
                request: .init(BookSlug: bookSlug, ChapterNumber: chapter, VerseNumber: verse, VersionName: version)
            )
            async let overviewTask = client.fetchBibleBookOverview(slug: bookSlug)
            async let takeawaysTask = client.fetchBibleVerseTakeaways(
                request: .init(BookSlug: bookSlug, ChapterNumber: chapter, VerseNumber: verse)
            )
            async let commentaryTask = client.fetchCommentaries(
                byVerse: .init(BookSlug: bookSlug, ChapterNumber: chapter, VerseNumber: verse, RequestType: "Combined", PreviewCount: 5)
            )

            verseVersion = try await versionTask
            bookOverview = try await overviewTask
            verseTakeaways = try await takeawaysTask
            let commentaries = try await commentaryTask
            commentaryCount = commentaries.count
        } catch let apiError as APIError {
            error = apiError
        } catch {
            error = .unknown(error)
        }
    }

    func loadCrossReferences(bookSlug: String, chapter: Int, verse: Int, version: String) async {
        crossReferences = (try? await client.fetchCrossReferences(
            request: .init(BookSlug: bookSlug, ChapterNumber: chapter, VerseNumber: verse, Version: version)
        )) ?? []
    }

    func loadInterlinear(bookSlug: String, chapter: Int, verse: Int) async {
        interlinearWords = (try? await client.fetchInterlinearVerse(
            request: .init(BookSlug: bookSlug, ChapterNumber: chapter, VerseNumber: verse)
        )) ?? []
    }
}
