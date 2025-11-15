import Foundation

// MARK: - Authors & Books
struct AuthorColorScheme: Codable, Hashable {
    let primary: String?
    let gradient: String?
    let outline: String?
    let chipBackground: String?
    let chipText: String?
    let fadeColor: String?
}

struct AuthorStats: Codable, Hashable {
    let sermonsPreached: Int?
    let publishedWorks: Int?
    let versesExposited: Int?
    let hymnsWritten: Int?
    let volumes: Int?
    let contributors: Int?
    let booksOfBible: Int?
}

struct AuthorBiography: Codable, Hashable {
    let summary: String
    let fullText: String?
}

struct AuthorMajorWork: Codable, Hashable, Identifiable {
    let id: String
    let title: String
    let description: String
    let purchaseLink: String?
}

struct AuthorLibraryEntry: Codable, Hashable, Identifiable {
    let id: String
    let title: String
    let date: String?
    let slug: String?
    let year: String?
}

struct AuthorContributor: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let role: String?
}

struct Author: Codable, Identifiable {
    let id: String
    let name: String
    let nicknameOrTitle: String?
    let birthYear: Int?
    let deathYear: Int?
    let nationality: String?
    let occupation: String?
    let religiousTradition: String?
    let sermonsPreached: Int?
    let slug: String
    let image: String?
    let colorScheme: AuthorColorScheme?
    let stats: AuthorStats?
    let biography: AuthorBiography?
    let majorWorks: [AuthorMajorWork]?
    let sermonLibrary: [AuthorLibraryEntry]?
    let hymnLibrary: [AuthorLibraryEntry]?
    let interestingFacts: [AuthorMajorWork]?
    let contributors: [AuthorContributor]?
    let isCommentaryCollection: Bool?
    let years: String?
    let displayName: String?
    let headerImageUrl: String?
    let profileImageUrl: String?
}

struct BibleBookInfo: Codable, Hashable, Identifiable {
    let slug: String
    let name: String
    var id: String { slug }
}

struct BookStructureEntry: Codable, Hashable, Identifiable {
    let id: String
    let bookOverviewId: String?
    let order: Int?
    let title: String?
    let description: String?
    let verses: String?
    let verseReferenceSlug: String?
}

struct BibleBookOverview: Codable, Hashable, Identifiable {
    let id: String
    let bookId: String?
    let author: String?
    let audience: String?
    let composition: String?
    let objective: String?
    let uniqueElements: String?
    let bookStructure: String?
    let keyThemes: String?
    let teachingHighlights: String?
    let historicalContext: String?
    let culturalBackground: String?
    let politicalLandscape: String?
    let bibleBook: BibleBookInfo?
    let bibleBookStructures: [BookStructureEntry]?
}

struct BookStructure: Codable {
    let chapters: Int
    let verses: [Int]
}

// MARK: - Verse references
struct BibleVerse: Codable, Hashable, Identifiable {
    let id: String
    let chapterId: String?
    let verseNumber: Int?
    let chapterNumber: Int?
    let bookSlug: String?
}

struct BibleVerseReference: Codable, Hashable, Identifiable {
    let id: String
    let startVerseId: String?
    let endVerseId: String?
    let startVerse: BibleVerse?
    let endVerse: BibleVerse?
    let referenceText: String?
}

struct BibleVerseVersion: Codable, Hashable, Identifiable {
    let id: String
    let verseId: String?
    let bibleVersionId: String?
    let content: String?
    let versionName: String?
    let slug: String?
    let verseNumber: Int?
}

struct BibleVerseRangeResponse: Codable, Hashable {
    let content: String?
    let reference: String?
    let versionName: String?
}

struct BibleVersionSummary: Codable, Hashable, Identifiable {
    let id: String
    let code: String
    let title: String
    let language: String
    let description: String?
}
