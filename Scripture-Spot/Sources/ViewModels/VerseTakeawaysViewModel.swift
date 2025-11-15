import Foundation
import SwiftUI
import Combine

@MainActor
final class VerseTakeawaysViewModel: ObservableObject {
    @Published var takeawaysByVerse: [Int: VerseTakeaway] = [:]
    @Published var verseContent: [Int: BibleVerseVersion] = [:]
    @Published var otherCommentaryAuthors: [Int: [Commentary]] = [:]
    @Published var isLoading = false

    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func loadChapter(bookSlug: String, chapter: Int, version: String) async {
        isLoading = true
        defer { isLoading = false }
        async let takeawaysTask = client.fetchBibleVerseTakeaways(request: .init(BookSlug: bookSlug, ChapterNumber: chapter, VerseNumber: 1))
        async let versesTask = client.fetchBibleVerses(request: .init(BookSlug: bookSlug, ChapterNumber: chapter))

        let takeaways = (try? await takeawaysTask) ?? []
        takeawaysByVerse = Dictionary(uniqueKeysWithValues: takeaways.compactMap { takeaway in
            guard let verseNumber = takeaway.bibleVerseReference?.startVerse?.verseNumber else { return nil }
            return (verseNumber, takeaway)
        })

        let verses = (try? await versesTask) ?? []
        verseContent = Dictionary(uniqueKeysWithValues: verses.compactMap { verse in
            guard let number = verse.verseNumber else { return nil }
            return (number, verse)
        })

        // Prefetch commentaries for the first few verses to keep UI active
        let previewVerses = takeawaysByVerse.keys.sorted().prefix(3)
        for verseNumber in previewVerses {
            let commentaryRequest = CommentaryByVerseRequest(BookSlug: bookSlug, ChapterNumber: chapter, VerseNumber: verseNumber, RequestType: "Preview", PreviewCount: 3)
            let commentaries = (try? await client.fetchCommentaries(byVerse: commentaryRequest)) ?? []
            otherCommentaryAuthors[verseNumber] = commentaries
        }
    }

    func toggleBookmark(for verse: Int) {
        // Will integrate once bookmark create endpoint is finalized on mobile
    }
}
