import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum APIError: LocalizedError {
    case invalidURL
    case decodingFailed
    case server(status: Int, message: String)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid API URL"
        case .decodingFailed: return "Unable to decode server response"
        case .server(let status, let message): return "Server error (\(status)): \(message)"
        case .unknown(let error): return error.localizedDescription
        }
    }
}

struct APIConfiguration {
    static let shared = APIConfiguration()
    let baseURL: URL
    let defaultVersion: String

    init() {
        let info = Bundle.main.infoDictionary ?? [:]
        let fallbackBase = "https://api.example.com"
        let base = info["SCRIPTURE_API_BASE_URL"] as? String ?? fallbackBase
        guard let url = URL(string: base) else {
            fatalError("Missing SCRIPTURE_API_BASE_URL in Info.plist")
        }
        baseURL = url
        defaultVersion = info["SCRIPTURE_DEFAULT_VERSION"] as? String ?? "asv"
    }
}

final class APIClient {
    static let shared = APIClient()

    private let session: URLSession
    private let configuration: APIConfiguration
    private let sessionManager: SessionManager

    init(session: URLSession = .shared,
         configuration: APIConfiguration = .shared,
         sessionManager: SessionManager = .shared) {
        self.session = session
        self.configuration = configuration
        self.sessionManager = sessionManager
    }

    func send<T: Decodable, Body: Encodable>(
        _ path: String,
        method: HTTPMethod = .get,
        query: [URLQueryItem]? = nil,
        body: Body? = nil,
        headers: [String: String] = [:],
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        var components = URLComponents(url: configuration.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        components?.queryItems = query?.isEmpty == false ? query : nil
        guard let url = components?.url else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        var mergedHeaders = headers
        if let token = sessionManager.currentToken {
            mergedHeaders["Authorization"] = "Bearer \(token)"
        }
        mergedHeaders.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.server(status: -1, message: "No response")
            }
            guard (200..<300).contains(httpResponse.statusCode) else {
                let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw APIError.server(status: httpResponse.statusCode, message: message)
            }
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            return try decoder.decode(T.self, from: data)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.unknown(error)
        }
    }
}

// MARK: - Request Payloads
struct CommentaryByVerseRequest: Encodable {
    let BookSlug: String
    let ChapterNumber: Int
    let VerseNumber: Int
    let RequestType: String
    let PreviewCount: Int?
}

struct CommentaryByChapterRequest: Encodable {
    let AuthorSlug: String
    let BookSlug: String
    let ChapterNumber: Int
    let RequestType: String
    let VersionName: String
}

struct CommentaryAvailabilityRequest: Encodable {
    let AuthorSlug: String
    let BookSlugs: [String]
}

struct ChapterAvailabilityRequest: Encodable {
    let AuthorSlug: String
    let BookSlug: String
    let ChapterNumbers: [Int]
}

struct BibleVersesRequest: Encodable {
    let BookSlug: String
    let ChapterNumber: Int
}

struct BibleVerseRangeRequest: Encodable {
    let BookSlug: String
    let ChapterNumber: Int
    let VerseRange: String
    let VersionName: String
}

struct BibleVerseVersionRequest: Encodable {
    let BookSlug: String
    let ChapterNumber: Int
    let VerseNumber: Int
    let VersionName: String
}

struct BibleVerseTakeawayRequest: Encodable {
    let BookSlug: String
    let ChapterNumber: Int
    let VerseNumber: Int
}

struct CrossReferenceRequest: Encodable {
    let BookSlug: String
    let ChapterNumber: Int
    let VerseNumber: Int
    let Version: String
}

struct InterlinearVerseRequest: Encodable {
    let BookSlug: String
    let ChapterNumber: Int
    let VerseNumber: Int
}

struct LexiconEntryRequest: Encodable {
    let StrongsKey: String
}

struct LexiconReferencesRequest: Encodable {
    let StrongsKey: String
    let Version: String
}

struct SearchRequest: Encodable {
    let Query: String
    let Page: Int
    let PageSize: Int
}

// MARK: - Endpoint Helpers
extension APIClient {
    func fetchAuthors() async throws -> [Author] {
        try await send("Authors/Authors")
    }

    func fetchCommentaries(byVerse request: CommentaryByVerseRequest) async throws -> [Commentary] {
        try await send("Authors/Commentaries/Verse", method: .get, query: request.queryItems)
    }

    func fetchCommentaries(byChapter request: CommentaryByChapterRequest) async throws -> [Commentary] {
        try await send("Authors/Commentaries/Chapter", method: .get, query: request.queryItems)
    }

    func fetchCommentaryAvailability(request: CommentaryAvailabilityRequest) async throws -> [String: Bool] {
        try await send("Authors/Commentaries/Availability", method: .post, body: request)
    }

    func fetchChapterAvailability(request: ChapterAvailabilityRequest) async throws -> [String: Bool] {
        try await send("Authors/Commentaries/Chapter/Availability", method: .post, body: request)
    }

    func fetchBibleBooks() async throws -> [BibleBookInfo] {
        try await send("Bible/Books")
    }

    func fetchBibleChapters(bookSlug: String) async throws -> [[String: Int]] {
        try await send("Bible/Chapters", method: .get, query: [.init(name: "BookSlug", value: bookSlug)])
    }

    func fetchBibleVerses(request: BibleVersesRequest) async throws -> [BibleVerseVersion] {
        try await send("Bible/Verses", method: .get, query: request.queryItems)
    }

    func fetchBibleVerseRange(request: BibleVerseRangeRequest) async throws -> BibleVerseRangeResponse {
        try await send("Bible/Verse/Range", method: .get, query: request.queryItems)
    }

    func fetchBibleVerseVersion(request: BibleVerseVersionRequest) async throws -> BibleVerseVersion {
        try await send("Bible/Verse/Version", method: .get, query: request.queryItems)
    }

    func fetchBibleVerseTakeaways(request: BibleVerseTakeawayRequest) async throws -> [VerseTakeaway] {
        try await send("Bible/Verse/Takeaways", method: .get, query: request.queryItems)
    }

    func fetchBibleBookOverview(slug: String) async throws -> BibleBookOverview {
        try await send("Bible/Book/Overview", method: .get, query: [.init(name: "slug", value: slug)])
    }

    func fetchBibleVersions() async throws -> [BibleVersionSummary] {
        try await send("Bible/Versions")
    }

    func fetchCrossReferences(request: CrossReferenceRequest) async throws -> [CrossReferenceKeyword] {
        try await send("Bible/Verse/CrossReferences", method: .get, query: request.queryItems)
    }

    func fetchInterlinearVerse(request: InterlinearVerseRequest) async throws -> [InterlinearWord] {
        try await send("Exploration/Interlinear/Verse", method: .get, query: request.queryItems)
    }

    func fetchLexiconEntry(key: String) async throws -> StrongsLexiconEntry {
        try await send("Exploration/Lexicon/Entry", method: .get, query: [.init(name: "StrongsKey", value: key)])
    }

    func fetchLexiconReferences(request: LexiconReferencesRequest) async throws -> [VerseReferenceOccurrence] {
        try await send("Exploration/Lexicon/Verse/References", method: .get, query: request.queryItems)
    }

    func fetchBookmarks(token: String) async throws -> BookmarksResponse {
        try await send("User/Bookmarks", method: .get, headers: ["Authorization": "Bearer \(token)"])
    }

    func createBookmark(request: CreateBookmarkRequest, token: String) async throws {
        let _: EmptyResponse = try await send("User/Bookmark", method: .post, body: request, headers: ["Authorization": "Bearer \(token)"])
    }

    func deleteBookmark(request: DeleteBookmarkRequest, token: String) async throws {
        let _: EmptyResponse = try await send("User/Bookmark", method: .delete, body: request, headers: ["Authorization": "Bearer \(token)"])
    }

    func performSearch(request: SearchRequest) async throws -> [SearchGroup] {
        try await send("Search", method: .get, query: request.queryItems)
    }

    func fetchLandingPage(slug: String) async throws -> LandingPage {
        try await send("LandingPages", method: .get, query: [.init(name: "slug", value: slug)])
    }

    func fetchVerseOfTheDay(version: String) async throws -> VerseOfTheDayResponse {
        try await send("VerseOfTheDay", method: .get, query: [.init(name: "Version", value: version)])
    }

    func fetchReaderChapter(author: String, book: String, chapter: Int) async throws -> ReaderChapterPayload {
        try await send(
            "Books/Reader",
            method: .get,
            query: [
                .init(name: "author", value: author),
                .init(name: "book", value: book),
                .init(name: "chapter", value: "\(chapter)")
            ]
        )
    }
}

private struct EmptyResponse: Codable {}

private extension Encodable {
    var queryItems: [URLQueryItem] {
        guard let data = try? JSONEncoder().encode(self),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return [] }
        return dict.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
    }
}

private extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
