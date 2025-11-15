import Foundation

enum BookmarkType: String, Codable, CaseIterable, Identifiable {
    case commentary = "Commentary"
    case hymn = "Hymn"
    case sermon = "Sermon"
    case catechism = "Catechism"
    case creed = "Creed"
    case devotional = "Devotional"
    case bookHighlight = "BookHighlight"
    case verse = "Verse"
    case verseVersion = "VerseVersion"
    case bookOverview = "BookOverview"
    case takeaway = "Takeaway"
    case strongsConcordance = "StrongsConcordance"

    var id: String { rawValue }
}

struct BookmarkHighlight: Codable, Hashable {
    let label: String
    let value: String
}

struct Bookmark: Codable, Identifiable {
    let id: String
    let userId: String
    let contentType: BookmarkType
    let contentId: String
    let title: String
    let description: String?
    let reference: String?
    let author: Author?
    let slug: String?
    let tags: [String]?
    let createdAt: Date
    let updatedAt: Date
    let commentary: Commentary?
    let verse: BibleVerse?
    let verseVersion: BibleVerseVersion?
    let bookOverview: BibleBookOverview?
    let takeaway: VerseTakeaway?
    let strongsEntry: StrongsLexiconEntry?
    let highlights: [BookmarkHighlight]?
}

struct BookmarkDisplay: Identifiable, Codable {
    var id: String { bookmark.id }
    let bookmark: Bookmark
    let formattedReference: String?
    let formattedDate: String?
    let displayTags: [String]?
    let excerpt: String?
    let monthYear: String?
    let hymnText: String?
    let sermonText: String?
    let highlightedText: String?
    let bookTitle: String?
    let bookChapter: String?
}

struct BookmarkGroup: Codable, Identifiable {
    let monthYear: String
    let displayName: String
    let bookmarks: [BookmarkDisplay]
    let count: Int
    var id: String { monthYear }
}

enum BookmarkSortOrder: String, Codable, CaseIterable {
    case newest
    case oldest
    case alphabetical
}

struct BookmarkFilters: Codable {
    var contentTypes: [BookmarkType]
    var searchQuery: String
    var sortBy: BookmarkSortOrder

    static var `default`: BookmarkFilters {
        BookmarkFilters(contentTypes: [], searchQuery: "", sortBy: .newest)
    }
}

struct BookmarksResponse: Codable {
    let bookmarks: [Bookmark]
    let totalCount: Int
    let hasMore: Bool
}

struct CreateBookmarkRequest: Codable {
    let id: String
    let type: BookmarkType
    let userId: String
}

struct DeleteBookmarkRequest: Codable {
    let id: String
    let userId: String
}
