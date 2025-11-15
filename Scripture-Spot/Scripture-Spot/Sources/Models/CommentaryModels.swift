import Foundation

struct VerseTakeawayExcerpt: Codable, Hashable, Identifiable {
    let id: String
    let takeAwayId: String?
    let order: Int?
    let title: String?
    let content: String?
}

struct VerseTakeawayQuote: Codable, Hashable, Identifiable {
    let id: String
    let takeAwayId: String?
    let authorId: String?
    let order: Int?
    let title: String?
    let content: String?
    let source: String?
    let author: Author?
}

struct VerseTakeaway: Codable, Identifiable {
    let id: String
    let bibleReferenceId: String?
    let slug: String?
    let commentaryAuthors: String?
    let bibleVerseReference: BibleVerseReference?
    let excerpts: [VerseTakeawayExcerpt]?
    let quotes: [VerseTakeawayQuote]?
}

struct CommentaryExcerpt: Codable, Hashable, Identifiable {
    let id: String
    let order: Int?
    let content: String?
    let type: String?
}

struct Commentary: Codable, Identifiable {
    let id: String
    let authorId: String?
    let bibleReferenceId: String?
    let slug: String?
    let source: String?
    let sourceUrl: String?
    let groupId: String?
    let previewContent: String?
    let bibleVerseReference: BibleVerseReference?
    let author: Author?
    let excerpts: [CommentaryExcerpt]?
}

struct CommentaryGroup: Identifiable, Hashable {
    let id = UUID()
    let verse: Int
    let commentaries: [Commentary]
}
