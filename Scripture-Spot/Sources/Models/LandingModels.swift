import Foundation

struct LandingPageComponent: Codable, Identifiable {
    let id: String
    let landingPageId: String
    let componentType: String
    let entityId: String
    let order: Int?
    let allowRandomOrder: Bool?
}

struct LandingPage: Codable, Identifiable {
    let id: String
    let slug: String?
    let referenceSlug: String?
    let header: String?
    let subheader: String?
    let metaKeywords: String?
    let metaDescription: String?
    let components: [LandingPageComponent]?
}

struct ReaderChapterPayload: Codable {
    let title: String
    let content: String
    let author: Author?
    let book: BibleBookInfo?
    let chapter: Int
    let version: String?
}

struct VerseOfTheDayResponse: Codable {
    let text: String
    let reference: String
    let version: String?
}

struct MetaData: Codable {
    let currentPage: Int
    let totalPages: Int
    let pageSize: Int
    let totalCount: Int
}

struct PaginatedResponse<T: Codable>: Codable {
    let items: T
    let metaData: MetaData
}
