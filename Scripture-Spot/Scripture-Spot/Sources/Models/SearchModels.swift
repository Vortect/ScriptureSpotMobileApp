import Foundation

struct CrossReference: Codable, Hashable {
    let label: String
    let slug: String
    let text: String
}

struct CrossReferenceKeyword: Codable, Hashable, Identifiable {
    let keyword: String
    let bibleVerseReferences: [CrossReference]
    var id: String { keyword }
}

struct SearchEntry: Codable, Hashable, Identifiable {
    let id: String
    let slug: String
    let reference: String
    let text: String
    let authorName: String?
}

struct SearchGroup: Codable, Hashable, Identifiable {
    let type: String
    let entries: [SearchEntry]
    var id: String { type }
}

struct BalancedSearchResponse: Codable {
    let groups: [SearchGroup]
}
