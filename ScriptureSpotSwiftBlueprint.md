# ScriptureSpotSwiftBlueprint.md

## SECTION A — PROJECT OVERVIEW
- **Purpose** – The Next.js app wraps a study workflow around Scripture: it injects custom font stacks, analytics, Clerk auth, PostHog, toast provider, ads and marketing modals inside `RootLayout`, highlighting that every screen sits inside a dark theme with tool overlays for study (`src/app/layout.tsx:1`).  
- **Core Screens** –  
  - *Home dashboard* shows verse-of-the-day, resume cards and quick links via gradient `FeatureCard`s (`src/components/home/HomePage.tsx:1`).  
  - *Bible explorer* flows from translations → book grid → chapter grid → chapter reader using `BibleBooksPage`, `BibleChaptersPage`, `BibleChapterPage`, `ChapterContent`, and `ChapterNavigation` (`src/components/bible/BibleBooksPage.tsx:1`, `BibleChaptersPage.tsx:1`, `BibleChapterPage.tsx:1`, `ChapterContent.tsx:1`, `ChapterNavigation.tsx:1`).  
  - *Verse detail* couples header, study toggles, navigation bar, commentary grid, verse takeaways, book overview, cross-references and interlinear drawers (`src/components/verse/VersePage.tsx:1`, `VerseHeader.tsx:1`, `VerseNavigationBar.tsx:1`, `VerseActions.tsx:1`, `CrossReferencesDrawer.tsx:1`, `InterlinearDrawer.tsx:1`, `OverviewGrid.tsx:1`).  
  - *Commentary workflows* include commentator index, author detail, book selection, chapter-level grids and verse-range pages buffered by `AuthorCard`, `AuthorPage`, `AuthorCommentariesPage`, `CommentaryChapterPage`, `CommentaryVersePage`, and `VerseTakeaways*` pages (`src/components/commentators/CommentatorsPage.tsx:1`, `AuthorPage.tsx:1`, `AuthorCommentariesPage.tsx:1`, `CommentaryChapterPage.tsx:1`, `CommentaryVersePage.tsx:1`, `VerseTakeawaysChapterPage.tsx:1`).  
  - *Library* wraps Clerk-protected bookmarks with grouping, filtering, delete modal and cards (`src/components/bookmarks/BookmarksPage.tsx:1`, `BookmarkCard.tsx:1`, `BookmarkFilters.tsx:1`, `BookmarkDeleteModal.tsx:1`).  
  - *Lexicon + Strongs* replicates tagged interlinear cards, verse occurrences, bookmarking and share flows (`src/components/strongs/StrongsLexiconPage.tsx:1`, `StrongsHeader.tsx:1`, `StrongsVerseReferences.tsx:1`).  
  - *Search* hydrates a server-prefetched query and renders results inside `/search` (`src/app/(no-sidebar)/search/page.tsx:1`).  
  - *Reader* loads theological works (e.g., Calvin) via `BookReader` for `/books/:author/:book/:chapter` (`src/app/books/[author]/[book]/[chapter]/page.tsx:1`).  
- **Core Data Entities** – All top-level JSON contracts live in `src/types`, covering authors, bookmarks, bible books, book structures, verse references, takeaways, lexicon entries, landing pages, pagination metadata, etc. (`src/types/author.ts:1`, `src/types/bookmark.ts:1`, `src/types/landingPage.ts:1`, `src/data/bibleBooks.ts:1`, `src/data/bibleStructure.ts:1`).  
- **UI Patterns** –  
  - Gradient hero cards and glassmorphic chips from `AuthorCard`, `BibleBookCard`, `BibleVersionCard`, `VerseTakeawaysCard`, `BookOverviewCard` and `SupportCard`s rely on consistent radii and outlines (`src/components/author/AuthorCard.tsx:1`, `src/components/bible/BibleBookCard.tsx:1`, `src/components/bible/BibleVersionCard.tsx:1`, `src/components/overview/VerseTakeawaysCard.tsx:1`).  
  - Chip styling centralizes in `CustomChip` while action buttons rely on `IconActionButton` to provide hover colors, glows and tooltips (`src/components/ui/CustomChip.tsx:1`, `src/components/verse/IconActionButton.tsx:1`).  
  - Modals/drawers use Radix + motion in `VersePickerSheet`, `CrossReferencesDrawer`, `InterlinearDrawer`, `StrongsModal`, and `BookmarkDeleteModal` with consistent overlay transitions (`src/components/common/VersePickerSheet.tsx:1`, `src/components/verse/CrossReferencesDrawer.tsx:1`, `src/components/verse/InterlinearDrawer.tsx:1`, `src/components/verse/StrongsModal.tsx:1`, `src/components/bookmarks/BookmarkDeleteModal.tsx:1`).  
  - Skeleton shimmer styles unify loading states (`src/styles/skeletonStyles.ts:1`).  
- **Navigation Flows** –  
  - Layouts `MainLayout` (with sidebar) and `MinimalLayout` (without) wrap most routes, while `HeaderNavigation` groups Explore/Study/Library drop-downs and uses Radix navigation menu for mega menus (`src/app/(with-sidebar)/layout.tsx:1`, `src/app/(no-sidebar)/layout.tsx:1`, `src/components/layout/HeaderNavigation.tsx:1`).  
  - Desktop adds `SidebarColumn` with quick verse links, verse-of-day and support CTA (`src/components/layout/SidebarColumn.tsx:1`).  
  - Dynamic Next routes cover `/[version]/[book]/[chapter]/[verse]`, `/commentators/:id/...`, `/commentators/verse-takeaways/...`, `/strongs/:key`, `/bookmarks`, `/translations`, `/books/:author/:book/:chapter`, and `/search`.  

## SECTION B — DATA MODELS (SWIFT)
```swift
import Foundation

// MARK: - Bible + Author Models
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

// MARK: - Verse References & Versions
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
}

struct BibleVerseRangeResponse: Codable, Hashable {
    let content: String?
    let reference: String?
    let versionName: String?
}

// MARK: - Commentary Models
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

// MARK: - Lexicon & Interlinear
struct StrongsLexiconEntry: Codable, Identifiable {
    let id: String
    let strongsKey: String?
    let shortDefinition: String?
    let originalWord: String?
    let partOfSpeech: String?
    let transliteration: String?
    let pronunciation: String?
    let phoneticSpelling: String?
    let kjvTranslation: String?
    let nasbTranslation: String?
    let wordOrigin: String?
    let strongsDef: String?
    let bdbDef: String?
    let frequency: Int?
    let language: String?
}

struct InterlinearWord: Codable, Hashable, Identifiable {
    let englishWord: String
    let transliteration: String
    let strongsKey: String
    let grammarCompact: String
    let grammarDetailed: String
    let punctuation: String?
    let wordPosition: Int
    let hebrewWord: String?
    let greekWord: String?

    enum CodingKeys: String, CodingKey {
        case englishWord = "english_word"
        case transliteration
        case strongsKey = "strongs_key"
        case grammarCompact = "grammar_compact"
        case grammarDetailed = "grammar_detailed"
        case punctuation
        case wordPosition = "word_position"
        case hebrewWord = "hebrew_word"
        case greekWord = "greek_word"
    }

    var id: Int { wordPosition }
}

struct VerseReferenceOccurrence: Codable, Hashable, Identifiable {
    let book: String
    let chapter: Int
    let verse: Int
    let text: String
    let reference: String
    var id: String { "\(book)-\(chapter)-\(verse)" }
}

// MARK: - Cross References & Search
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

// MARK: - Bookmarks & Library
enum BookmarkType: String, Codable, CaseIterable {
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

struct BookmarkGroup: Codable, Hashable, Identifiable {
    let monthYear: String
    let displayName: String
    let bookmarks: [BookmarkDisplay]
    let count: Int
    var id: String { monthYear }
}

enum BookmarkSortOrder: String, Codable {
    case newest, oldest, alphabetical
}

struct BookmarkFilters: Codable {
    var contentTypes: [BookmarkType]
    var searchQuery: String
    var sortBy: BookmarkSortOrder
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

// MARK: - Landing Pages & Reader
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

// MARK: - Verse Of The Day & Pagination
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
```

## SECTION C — API SERVICE LAYER
```swift
import Foundation

enum HTTPMethod: String {
    case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
}

enum APIError: Error {
    case invalidURL
    case decodingFailed
    case server(status: Int, message: String)
    case unknown(Error)
}

struct APIConfiguration {
    static let shared = APIConfiguration()
    let baseURL: URL
    let defaultVersion: String

    init() {
        let info = Bundle.main.infoDictionary ?? [:]
        let apiBase = info["SCRIPTURE_API_BASE_URL"] as? String ?? "https://api.example.com"
        let defaultVersion = info["SCRIPTURE_DEFAULT_VERSION"] as? String ?? "asv"
        guard let url = URL(string: apiBase) else {
            fatalError("Missing SCRIPTURE_API_BASE_URL")
        }
        self.baseURL = url
        self.defaultVersion = defaultVersion
    }
}

struct APIClient {
    static let shared = APIClient()
    private let session = URLSession(configuration: .default)
    private let config = APIConfiguration.shared
    private let sessionManager = SessionManager.shared

    func send<T: Decodable, Body: Encodable>(
        _ path: String,
        method: HTTPMethod = .get,
        query: [URLQueryItem]? = nil,
        body: Body? = Optional<String>.none,
        headers: [String: String] = [:],
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        var components = URLComponents(url: config.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
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

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw APIError.server(status: -1, message: "No response")
        }
        guard (200..<300).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw APIError.server(status: http.statusCode, message: message)
        }

        do {
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }
}

// MARK: - Request payloads (PascalCase keys match server)
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

// MARK: - Endpoint helpers
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

    func fetchBibleVersions() async throws -> [[String: String?]] {
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
        _ = try await send("User/Bookmark", method: .post, body: request, headers: ["Authorization": "Bearer \(token)"]) as EmptyResponse
    }

    func deleteBookmark(request: DeleteBookmarkRequest, token: String) async throws {
        _ = try await send("User/Bookmark", method: .delete, body: request, headers: ["Authorization": "Bearer \(token)"]) as EmptyResponse
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
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .iso8601)
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return df
    }()
}
```

## SECTION D — ARCHITECTURE (MVVM)
- **HomeViewModel** (`HomeScreen`)  
  - State: `@Published var verseOfTheDay: VerseOfTheDayResponse?`, `@Published var lastVerse: BookmarkDisplay?`, `@Published var lastPage: BookmarkDisplay?`, `@Published var isLoading`.  
  - Methods: `loadVerseOfTheDay(version: String)`, `restoreLastActivity()` reading persisted values, `presentQuickLinks()`.  
  - API: `APIClient.fetchVerseOfTheDay`, local storage for last verse/page.

- **BibleVersionsViewModel** (`TranslationsScreen`)  
  - State: `@Published var versions: [BibleVersionSummary]`, `@Published var isLoading`, `@Published var error`.  
  - Methods: `loadVersions()`.  
  - API: `fetchBibleVersions()`.

- **BibleBooksViewModel** (`BibleBooksScreen`)  
  - State: `@Published var books: [BibleBookInfo]`, `@Published var versionSlug`, `@Published var pendingBookSlug`.  
  - Methods: `loadBooks()`, `selectBook(_:)`.  
  - Data from `fetchBibleBooks()` and static `BibleBookInfo`.

- **BibleChaptersViewModel** (`BibleChaptersScreen`)  
  - State: `@Published var chapters: [Int]`, `@Published var isLoading`, `@Published var pendingChapter`.  
  - Methods: `loadChapters(bookSlug:)`, `selectChapter(_:)`.  
  - API: `fetchBibleChapters`.

- **BibleChapterViewModel** (`BibleChapterScreen`)  
  - State: `@Published var verses: [BibleVerseVersion]`, `@Published var verseRangeHTML: String?`, `@Published var neighborChapters: [Int]`, `@Published var isLoading`.  
  - Methods: `loadChapter(bookSlug:chapter:version:)`, `prefetchVerseRange()`.  
  - API: `fetchBibleVerses`, `fetchBibleVerseRange`, `fetchBibleChapters`.

- **VerseDetailViewModel** (`VerseDetailScreen`)  
  - State: 
    - `@Published var verseVersion: BibleVerseVersion?`
    - `@Published var bookOverview: BibleBookOverview?`
    - `@Published var verseTakeaways: [VerseTakeaway]`
    - `@Published var commentaryCount: Int`
    - `@Published var crossReferences: [CrossReferenceKeyword]`
    - `@Published var interlinearWords: [InterlinearWord]`
    - `@Published var error: APIError?`
    - `@Published var isLoading: Bool`.  
  - Methods: `loadVerse(bookSlug:chapter:verse:version:)`, `toggleBookmark()`, `loadCrossReferences()`, `loadInterlinear()`, `openDrawer(type:)`.  
  - API: `fetchBibleVerseVersion`, `fetchBibleBookOverview`, `fetchBibleVerseTakeaways`, `fetchCommentaries`, `fetchCrossReferences`, `fetchInterlinearVerse`.

- **CommentatorsListViewModel** (`CommentatorsScreen`)  
  - State: `@Published var authors: [Author]`, `@Published var fetchError`.  
  - Methods: `loadAuthors()`.  
  - API: `fetchAuthors()`.

- **AuthorDetailViewModel** (`AuthorScreen`)  
  - State: `@Published var author: Author?`, `@Published var availableBooks: [BibleBookInfo]`, `@Published var bookAvailability: [String: Bool]`, `@Published var isLoading`.  
  - Methods: `hydrate(slug:)`, `loadAvailability(for:)`.  
  - API: `fetchAuthors`, `fetchCommentaryAvailability`.

- **AuthorChapterViewModel** (`AuthorChapterScreen`)  
  - State: `@Published var chapters: [Int]`, `@Published var chapterAvailability: [Int: Bool]`, `@Published var initialCommentaries: [Commentary]`.  
  - Methods: `loadChapters(bookSlug:)`, `loadChapterAvailability(bookSlug:)`, `openChapter(_:)`.  
  - API: `fetchBibleChapters`, `fetchChapterAvailability`.

- **ChapterCommentaryViewModel** (`CommentaryChapterScreen`)  
  - State: `@Published var groupedCommentaries: [CommentaryGroup]`, `@Published var version`.  
  - Methods: `loadChapter(authorSlug:book:chapter:)`, `changeVersion(_:)`, `scrollToVerse(_:)`.  
  - API: `fetchCommentaries(byChapter:)`.

- **VerseTakeawaysViewModel** (`VerseTakeawaysScreens`)  
  - State: `@Published var takeawaysByVerse: [Int: VerseTakeaway]`, `@Published var verseContent: [Int: BibleVerseVersion]`, `@Published var otherCommentaryAuthors: [Int: [Commentary]]`.  
  - Methods: `loadChapter(bookSlug:chapter:)`, `toggleBookmark(for:)`.  
  - API: `fetchBibleVerseTakeaways`, `fetchBibleVerseVersion`, `fetchCommentaries(byVerse:)`.

- **BookmarksViewModel** (`BookmarksScreen`)  
  - State: `@Published var groups: [BookmarkGroup]`, `@Published var filters: BookmarkFilters`, `@Published var isLoading`, `@Published var error`.  
  - Methods: `loadBookmarks(token:)`, `apply(filters:)`, `deleteBookmark(_:)`, `refetch()`.  
  - API: `fetchBookmarks`, `deleteBookmark`.

- **StrongsLexiconViewModel** (`StrongsScreen`)  
  - State: `@Published var entry: StrongsLexiconEntry?`, `@Published var occurrences: [VerseReferenceOccurrence]`, `@Published var highlightedTerms: [String]`, `@Published var isBookmarked`.  
  - Methods: `loadEntry(key:, version:)`, `bookmarkEntry(token:)`, `loadMoreOccurrences()`.  
  - API: `fetchLexiconEntry`, `fetchLexiconReferences`, `createBookmark`.

- **SearchViewModel** (`SearchScreen`)  
  - State: `@Published var query = ""`, `@Published var groups: [SearchGroup]`, `@Published var isSearching`.  
  - Methods: `submitSearch(query:)`, `rebalance()` replicating `useBalancedSearch`.  
  - API: `performSearch`.

- **ReaderViewModel** (`BookReaderScreen`)  
  - State: `@Published var chapter: ReaderChapterPayload?`, `@Published var isLoading`.  
  - Methods: `loadChapter(author:book:chapter:)`.  
  - API: `fetchAuthors`, `fetchBookChapter`.

### Session & Analytics Infrastructure
- **SessionManager** – Wraps Clerk auth: the iOS app launches `ASWebAuthenticationSession` against the hosted Clerk sign-in, listens for the `scripturespot://auth/callback`, exchanges it for a JWT using `env.clerkJwtTemplate` (see `src/types/env.ts:5`), and stores the token securely in Keychain. SessionManager publishes the active token (used by `APIClient`) and exposes helpers to refresh or clear credentials.
- **AnalyticsService** – Inspired by `PostHogProvider` (`src/providers/PostHogProvider.tsx`), define a protocol with methods like `trackScreen(name:)`, `trackVerseOpen(book:chapter:verse:)`, `trackLexiconKey(_:)`, and `trackBookmark(action:)`. Inject either a no-op or PostHog-backed implementation into view models so events remain decoupled from UI state.

### Persistence & Offline
- Mirror the web app’s localStorage usage (`src/components/home/HomePage.tsx:42`, `src/components/common/LastPageTracker.tsx:12`) with a `PersistenceStore` that keeps last verse/page, preferred version, and user preferences in `UserDefaults`.
- Plan a SwiftData cache for pinned verses, downloaded commentaries, lexicon entries, and bookmarks to support offline reading. Repository helpers can hydrate SwiftUI screens from SwiftData immediately, then merge API updates when online.

Each view model conforms to `@MainActor ObservableObject`, exposing async `Task` functions that call `APIClient` and update published properties with `withAnimation` where needed.

## SECTION E — NAVIGATION STRUCTURE
- **Root Container** – `ScriptureSpotApp` holds a single `NavigationStack` nested inside a `TabView`. Tabs mirror the web header sections:
  1. `Study` tab: `HomeScreen` (dashboard) + nested pushes for Verse detail and Verse takeaways.
  2. `Read` tab: `TranslationsScreen` → `BibleBooksScreen` → `BibleChaptersScreen` → `BibleChapterScreen` → `VerseDetailScreen`.
  3. `Commentary` tab: `CommentatorsScreen` → `AuthorScreen` → `AuthorBookPickerScreen` → `AuthorChapterScreen` → `CommentaryChapterScreen` → `CommentaryVerseScreen`.
  4. `Library` tab: `BookmarksScreen`.
  5. `Lexicon` tab: `StrongsScreen` accessible directly or from Verse detail drawers.
  6. `Search` tab: `SearchScreen` with query parameter binding.

- **Dynamic Paths** –  
  - The Bible flow mirrors `/[version]/[book]/[chapter]/[verse]`; `NavigationPath` stores `BibleRoute` enums for version/book/chapter/verse segments derived from `BIBLE_STRUCTURE`.  
  - Commentary flows encode `AuthorRoute` (author slug, book slug, chapter, optional verse range).  
  - Lexicon flows push `LexiconRoute(key:)`.  
  - Reader flows push `ReaderRoute(author:book:chapter:)`.

- **Sheet & Drawer Patterns** –  
  - Verse pickers or cross-reference drawers appear as `.sheet` or `.overlay`.  
  - `BookmarkDeleteModal` replicates Radix sheet by presenting `.bottomSheet`.  
  - Interlinear + cross references toggles in `VerseDetailScreen` push `DrawerState`.

- **Deep Links** – When shared, routes encode version/book/chap/verse or Strongs keys. `RootCoordinator` listens for `ScenePhase.active` and `onOpenURL` to parse.

## SECTION F — COMPONENT LIBRARY
- **GradientHeroCard** (for FeatureCard, SupportCard)  
  ```swift
  struct GradientHeroCard: View {
      let title: String
      let description: String
      let gradient: LinearGradient
      let actionTitle: String
      let action: () -> Void

      var body: some View {
          VStack(alignment: .leading, spacing: 12) {
              Text(title).font(.headline).foregroundStyle(.white)
              Text(description).font(.subheadline).foregroundColor(.white.opacity(0.7))
              Spacer()
              Button(actionTitle, action: action)
                  .buttonStyle(.gradientCTA(gradient))
          }
          .padding(20)
          .background(gradient.opacity(0.25))
          .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
          .overlay(RoundedRectangle(cornerRadius: 28).strokeBorder(.white.opacity(0.15), lineWidth: 2))
          .shadow(color: .black.opacity(0.35), radius: 16, y: 8)
      }
  }
  ```
- **ChipView (CustomChip analogue)**  
  ```swift
  struct ChipView: View {
      let label: String
      let bgColor: Color
      let textColor: Color
      var body: some View {
          Text(label.uppercased())
              .font(.footnote.weight(.semibold))
              .padding(.horizontal, 10).padding(.vertical, 4)
              .background(bgColor)
              .foregroundStyle(textColor)
              .clipShape(Capsule())
      }
  }
  ```
- **IconActionButton**  
  ```swift
  struct IconActionButton<Label: View>: View {
      let icon: () -> Label
      let text: String?
      let baseColor: Color
      let hoverColor: Color
      let glowColor: Color?
      let action: () -> Void
      @State private var pressed = false

      var body: some View {
          Button {
              action()
          } label: {
              HStack(spacing: 6) {
                  icon()
                  if let text { Text(text).font(.footnote).foregroundStyle(.white.opacity(0.9)) }
              }
              .padding(.horizontal, 12).padding(.vertical, 8)
              .background(pressed ? hoverColor : baseColor)
              .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
              .shadow(color: glowColor ?? .clear, radius: pressed ? 20 : 0)
          }
          .pressEvents(onPress: { pressed = true }, onRelease: { pressed = false })
      }
  }
  ```
- **VerseNavigationBar** – replicates previous/next toggles and version selector with `IconActionButton`s.  
- **VerseActionsBar** – stacks icon buttons for “Full Chapter”, “Bookmark”, “Copy”, “Share”.  
- **AuthorHeaderView** – two-column layout with gradient background, breadcrumbs and avatar referencing `AuthorHeader`.  
- **CommentaryCardView** – Compose `Author badge`, preview text (rendered via `AttributedText`), metadata chips, and `IconActionButton`s (open, share, toggle translation).  
- **VerseTakeawaysCardView** – gradient block showing first excerpt, list of categories, CTA to open modal.  
- **BookOverviewCardView** – gradient block summarizing categories in chips plus CTA.  
- **CrossReferenceListView** – sidebar showing keywords (List) and selected verse text, includes share/copy buttons.  
- **InterlinearWordCard** – For each `InterlinearWord`, display original script, transliteration, part of speech, and Strongs key; tap opens lexicon modal.  
- **BookmarkCardView** – replicate `BookmarkCard` layout with gradient background, meta tags, status chip, CTA.  
- **StrongsHeaderView** – uses `interlinearThemes` colors to show strongs number, transliteration, navigation arrows, share/bookmark buttons.
- **HTMLText** – Single entry point for rendering API-provided HTML (verse range content, commentary excerpts, reader chapters). Start with `AttributedString` parsing and swap to a `WKWebView` when complex markup appears, mirroring how `ChapterContent.tsx:62`, `CommentaryCard.tsx:121`, and `BookReaderPage.tsx:40` handle HTML.
- **LoadStateView/ErrorStateView** – Inspired by `CrossLoader` and `skeletonBaseSx`, define shared views that render spinners/skeletons and retry messaging whenever a view model is `.loading` or `.error`.

Each component exposes modifiers (`.cardStyle()`, `.drawerBackground()`) derived from Section G theme.

## SECTION G — THEME & DESIGN SYSTEM
```swift
import SwiftUI

enum AppColor {
    static let primary = Color(red: 0x27/255, green: 0x8E/255, blue: 0xFF/255)
    static let secondary = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let background = Color(red: 0x11/255, green: 0x11/255, blue: 0x11/255)
    static let surface = Color(red: 0x1A/255, green: 0x1A/255, blue: 0x1A/255)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.6)
    static let chipBlue = Color(red: 0x96/255, green: 0xC2/255, blue: 0xFF/255)
    static let gradientStart = Color(red: 0.58, green: 0.16, blue: 0.87)
    static let gradientEnd = Color(red: 0.09, green: 0.38, blue: 0.73)
}

struct AppTypography {
    static let headingLarge = Font.system(size: 28, weight: .bold, design: .rounded)
    static let headingMedium = Font.system(size: 23, weight: .semibold, design: .rounded)
    static let body = Font.system(size: 16, weight: .regular, design: .default)
    static let caption = Font.system(size: 13, weight: .medium, design: .default)
}

enum AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

extension View {
    func cardStyle(cornerRadius: CGFloat = 28) -> some View {
        self
            .padding(AppSpacing.lg)
            .background(AppColor.surface.opacity(0.95))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(AppColor.textPrimary.opacity(0.08), lineWidth: 1))
            .shadow(color: .black.opacity(0.35), radius: 24, y: 10)
    }

    func chipStyle(bg: Color = AppColor.primary.opacity(0.3), text: Color = AppColor.chipBlue) -> some View {
        self
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(bg)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .foregroundStyle(text)
    }

    func gradientBackground(_ gradient: LinearGradient) -> some View {
        self
            .background(gradient)
            .clipShape(RoundedRectangle(cornerRadius: 35, style: .continuous))
    }
}

struct InterlinearTheme {
    static let hebrew = (drawerBg: Color(hex: "#221F19"), buttonActive: Color(hex: "#FFD700"))
    static let greek = (drawerBg: Color(hex: "#131820"), buttonActive: Color(hex: "#89B7F9"))
}

private extension Color {
    init(hex: String) {
        var hexVal = hex
        if hexVal.hasPrefix("#") { hexVal.removeFirst() }
        let scanner = Scanner(string: hexVal)
        var value: UInt64 = 0
        scanner.scanHexInt64(&value)
        let r = Double((value >> 16) & 0xFF) / 255
        let g = Double((value >> 8) & 0xFF) / 255
        let b = Double(value & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
```

## SECTION H — FULL SWIFTUI PROJECT SCAFFOLD

### File Tree
```
Sources/
  App.swift
  Theme/
    Theme.swift
    Modifiers.swift
  Models/
    BibleModels.swift
    CommentaryModels.swift
    LexiconModels.swift
    BookmarkModels.swift
    SearchModels.swift
    LandingModels.swift
  Services/
    APIClient.swift
  ViewModels/
    HomeViewModel.swift
    BibleViewModels.swift
    VerseDetailViewModel.swift
    CommentaryViewModels.swift
    VerseTakeawaysViewModel.swift
    BookmarksViewModel.swift
    StrongsViewModel.swift
    SearchViewModel.swift
  Components/
    GradientHeroCard.swift
    ChipView.swift
    IconActionButton.swift
    AuthorHeaderView.swift
    VerseActionsBar.swift
    VerseNavigationBar.swift
    VerseTakeawaysCard.swift
    BookOverviewCard.swift
    CrossReferenceDrawer.swift
    InterlinearDrawer.swift
    BookmarkCardView.swift
  Screens/
    RootTabView.swift
    HomeScreen.swift
    TranslationsScreen.swift
    BibleBooksScreen.swift
    BibleChaptersScreen.swift
    BibleChapterScreen.swift
    VerseDetailScreen.swift
    CommentatorsScreen.swift
    AuthorScreen.swift
    AuthorBookPickerScreen.swift
    AuthorChapterScreen.swift
    CommentaryChapterScreen.swift
    VerseTakeawaysScreen.swift
    BookmarksScreen.swift
    StrongsScreen.swift
    SearchScreen.swift
    ReaderScreen.swift
```

### App.swift
```swift
import SwiftUI

@main
struct ScriptureSpotApp: App {
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var bibleVM = BibleNavigationViewModel()
    @StateObject private var bookmarksVM = BookmarksViewModel()
    @StateObject private var searchVM = SearchViewModel()
    @StateObject private var lexiconVM = StrongsViewModel()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(homeVM)
                .environmentObject(bibleVM)
                .environmentObject(bookmarksVM)
                .environmentObject(searchVM)
                .environmentObject(lexiconVM)
                .background(AppColor.background.ignoresSafeArea())
        }
    }
}
```

### Theme/Theme.swift
*(Contains Section G code.)*

### Theme/Modifiers.swift
```swift
import SwiftUI

struct GradientCTAStyle: ButtonStyle {
    let gradient: LinearGradient
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(.horizontal, 24).padding(.vertical, 12)
            .background(gradient)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

extension ButtonStyle where Self == GradientCTAStyle {
    static func gradientCTA(_ gradient: LinearGradient) -> GradientCTAStyle {
        GradientCTAStyle(gradient: gradient)
    }
}

extension View {
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        modifier(PressEventsModifier(onPress: onPress, onRelease: onRelease))
    }
}

private struct PressEventsModifier: ViewModifier {
    let onPress: () -> Void
    let onRelease: () -> Void

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in onPress() }
                .onEnded { _ in onRelease() })
    }
}
```

### Models Files
*(Use Section B structs; each file groups relevant structs, e.g., `BibleModels.swift` contains `Author`, `BibleBookInfo`, etc.)*

### Services/APIClient.swift
*(Use Section C implementation.)*

### ViewModels/HomeViewModel.swift
```swift
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var verseOfTheDay: VerseOfTheDayResponse?
    @Published var lastVersePath: String?
    @Published var lastVerseReference: String?
    @Published var lastPagePath: String?
    @Published var isLoading = false
    private let client = APIClient.shared

    func loadVerseOfTheDay(version: String) {
        Task {
            isLoading = true
            defer { isLoading = false }
            do {
                verseOfTheDay = try await client.fetchVerseOfTheDay(version: version)
            } catch {
                verseOfTheDay = nil
            }
        }
    }

    func restoreLastActivity() {
        lastVersePath = UserDefaults.standard.string(forKey: "lastVersePath")
        lastVerseReference = UserDefaults.standard.string(forKey: "lastVerseReference")
        lastPagePath = UserDefaults.standard.string(forKey: "lastPagePath")
    }
}
```

### ViewModels/BibleViewModels.swift
```swift
import SwiftUI

@MainActor
final class BibleNavigationViewModel: ObservableObject {
    @Published var versions: [BibleVersionSummary] = []
    @Published var books: [BibleBookInfo] = []
    @Published var chapters: [Int] = []
    @Published var verses: [BibleVerseVersion] = []
    @Published var verseRangeHTML: String?
    @Published var isLoading = false

    private let client = APIClient.shared
    private let defaultVersion = APIConfiguration.shared.defaultVersion

    func loadBooks() {
        Task {
            do { books = try await client.fetchBibleBooks() }
            catch { books = [] }
        }
    }

    func loadChapters(bookSlug: String) {
        Task {
            isLoading = true
            defer { isLoading = false }
            let raw = try? await client.fetchBibleChapters(bookSlug: bookSlug)
            chapters = raw?.compactMap { $0["chapterNumber"] } ?? []
        }
    }

    func loadChapter(bookSlug: String, chapter: Int, version: String? = nil) {
        Task {
            isLoading = true
            defer { isLoading = false }
            let versesRequest = BibleVersesRequest(BookSlug: bookSlug, ChapterNumber: chapter)
            verses = (try? await client.fetchBibleVerses(request: versesRequest)) ?? []
            if let verseCount = verses.last?.verseNumber {
                let rangeString = verseCount > 1 ? "1-\(verseCount)" : "1"
                let rangeRequest = BibleVerseRangeRequest(BookSlug: bookSlug, ChapterNumber: chapter, VerseRange: rangeString, VersionName: version ?? defaultVersion.uppercased())
                verseRangeHTML = (try? await client.fetchBibleVerseRange(request: rangeRequest).content)
            }
        }
    }
}
```

### ViewModels/VerseDetailViewModel.swift
```swift
import SwiftUI

@MainActor
final class VerseDetailViewModel: ObservableObject {
    @Published var verseVersion: BibleVerseVersion?
    @Published var bookOverview: BibleBookOverview?
    @Published var takeaways: [VerseTakeaway] = []
    @Published var crossReferences: [CrossReferenceKeyword] = []
    @Published var interlinearWords: [InterlinearWord] = []
    @Published var commentaryCount: Int = 0
    @Published var isLoading = false
    @Published var error: APIError?

    private let client = APIClient.shared

    func load(bookSlug: String, chapter: Int, verse: Int, version: String) {
        Task {
            isLoading = true; defer { isLoading = false }
            await withThrowingTaskGroup(of: Void.self) { group in
                group.addTask { [weak self] in
                    self?.verseVersion = try? await self?.client.fetchBibleVerseVersion(request: .init(BookSlug: bookSlug, ChapterNumber: chapter, VerseNumber: verse, VersionName: version))
                }
                group.addTask { [weak self] in
                    self?.bookOverview = try? await self?.client.fetchBibleBookOverview(slug: bookSlug)
                }
                group.addTask { [weak self] in
                    self?.takeaways = (try? await self?.client.fetchBibleVerseTakeaways(request: .init(BookSlug: bookSlug, ChapterNumber: chapter, VerseNumber: verse))) ?? []
                }
                group.addTask { [weak self] in
                    let request = CommentaryByVerseRequest(BookSlug: bookSlug, ChapterNumber: chapter, VerseNumber: verse, RequestType: "Combined", PreviewCount: 150)
                    self?.commentaryCount = (try? await self?.client.fetchCommentaries(byVerse: request).count) ?? 0
                }
            }
        }
    }

    func loadCrossReferences(bookSlug: String, chapter: Int, verse: Int, version: String) {
        Task {
            crossReferences = (try? await client.fetchCrossReferences(request: .init(BookSlug: bookSlug, ChapterNumber: chapter, VerseNumber: verse, Version: version))) ?? []
        }
    }

    func loadInterlinear(bookSlug: String, chapter: Int, verse: Int) {
        Task {
            interlinearWords = (try? await client.fetchInterlinearVerse(request: .init(BookSlug: bookSlug, ChapterNumber: chapter, VerseNumber: verse))) ?? []
        }
    }
}
```

*(Continue with other ViewModels analogously.)*

### Components/GradientHeroCard.swift
*(Use Section F snippet.)*

### Components/AuthorHeaderView.swift
```swift
struct AuthorHeaderView: View {
    let author: Author
    let title: String
    let subtitle: String
    let breadcrumbs: [Breadcrumb]

    struct Breadcrumb: Identifiable {
        let id = UUID()
        let label: String
        let destination: String?
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(breadcrumbs) { crumb in
                        if let destination = crumb.destination {
                            NavigationLink(destination: Text(destination)) { Text(crumb.label).font(.caption).foregroundColor(.white.opacity(0.7)) }
                        } else {
                            Text(crumb.label).font(.caption.weight(.semibold)).foregroundColor(.white)
                        }
                        if crumb.id != breadcrumbs.last?.id {
                            Image(systemName: "chevron.right").foregroundColor(.white.opacity(0.4)).font(.caption2)
                        }
                    }
                }
            }
            Text(title)
                .font(AppTypography.headingLarge)
                .foregroundStyle(.white)
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            HStack(spacing: 10) {
                if let imageURL = author.image, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 96, height: 96)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                VStack(alignment: .leading, spacing: 6) {
                    if let birth = author.birthYear, let death = author.deathYear {
                        ChipView(label: "\(birth) – \(death)", bgColor: .white.opacity(0.08), textColor: .white)
                    }
                    if let tradition = author.religiousTradition {
                        ChipView(label: tradition, bgColor: .white.opacity(0.08), textColor: .white)
                    }
                }
            }
        }
        .padding()
        .background(
            LinearGradient(colors: [
                Color(hex: author.colorScheme?.primary ?? "#5B41DE"),
                Color.black
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 26).strokeBorder(.white.opacity(0.15)))
    }
}
```

*(Define other components analogously, each referencing relevant view models.)*

### Screens/RootTabView.swift
```swift
struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeScreen()
            }
            .tabItem { Label("Study", systemImage: "house") }

            NavigationStack {
                TranslationsScreen()
            }
            .tabItem { Label("Read", systemImage: "book") }

            NavigationStack {
                CommentatorsScreen()
            }
            .tabItem { Label("Commentary", systemImage: "person.3") }

            NavigationStack {
                BookmarksScreen()
            }
            .tabItem { Label("Library", systemImage: "bookmark") }

            NavigationStack {
                StrongsScreen()
            }
            .tabItem { Label("Lexicon", systemImage: "text.magnifyingglass") }

            NavigationStack {
                SearchScreen()
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
        }
        .tint(AppColor.secondary)
    }
}
```

### Screens/HomeScreen.swift
```swift
struct HomeScreen: View {
    @EnvironmentObject private var homeVM: HomeViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                GradientHeroCard(
                    title: "Welcome to Scripture Spot",
                    description: homeVM.verseOfTheDay?.text ?? "Explore Biblical commentaries and insights.",
                    gradient: LinearGradient(colors: [AppColor.secondary, AppColor.primary], startPoint: .topLeading, endPoint: .bottomTrailing),
                    actionTitle: "Read Verse"
                ) {
                    // Navigate to verse detail using stored reference
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    if let path = homeVM.lastVersePath {
                        GradientHeroCard(title: "Continue Reading", description: homeVM.lastVerseReference ?? path, gradient: LinearGradient(colors: [AppColor.primary, AppColor.primary.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing), actionTitle: "Resume") {
                            // Navigate to stored verse
                        }
                    }
                    GradientHeroCard(title: "Browse Commentaries", description: "See trusted voices on any passage.", gradient: LinearGradient(colors: [AppColor.gradientStart, AppColor.gradientEnd], startPoint: .leading, endPoint: .trailing), actionTitle: "Open") {
                        // Navigate to commentators tab
                    }
                }
            }
            .padding()
        }
        .onAppear {
            homeVM.restoreLastActivity()
            if homeVM.verseOfTheDay == nil {
                homeVM.loadVerseOfTheDay(version: APIConfiguration.shared.defaultVersion.uppercased())
            }
        }
    }
}
```

### Screens/BibleBooksScreen.swift
```swift
struct BibleBooksScreen: View {
    @EnvironmentObject private var bibleVM: BibleNavigationViewModel
    let versionSlug: String

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 16) {
                ForEach(bibleVM.books) { book in
                    Button {
                        bibleVM.loadChapters(bookSlug: book.slug)
                    } label: {
                        Text(book.name)
                            .frame(maxWidth: .infinity, minHeight: 80)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppColor.primary.opacity(0.8))
                }
            }
            .padding()
        }
        .navigationTitle(versionSlug.uppercased())
        .task {
            if bibleVM.books.isEmpty {
                bibleVM.loadBooks()
            }
        }
    }
}
```

### Screens/BibleChaptersScreen.swift
```swift
struct BibleChaptersScreen: View {
    @EnvironmentObject private var bibleVM: BibleNavigationViewModel
    let bookSlug: String
    let bookName: String

    var body: some View {
        Group {
            if bibleVM.isLoading {
                ProgressView("Loading chapters…")
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 12) {
                        ForEach(bibleVM.chapters, id: \.self) { chapter in
                            Button {
                                bibleVM.loadChapter(bookSlug: bookSlug, chapter: chapter)
                            } label: {
                                Text("\(chapter)")
                                    .frame(maxWidth: .infinity, minHeight: 60)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(bookName)
        .task {
            bibleVM.loadChapters(bookSlug: bookSlug)
        }
    }
}
```

### Screens/BibleChapterScreen.swift
```swift
struct BibleChapterScreen: View {
    @EnvironmentObject private var bibleVM: BibleNavigationViewModel
    @State private var selectedVerse: Int?
    let bookSlug: String
    let bookName: String
    let chapter: Int
    let version: String

    var body: some View {
        VStack(spacing: 24) {
            VerseActionsBar(
                onBookmark: {},
                onShare: {},
                onCopy: {},
                onFullChapter: {},
                isBookmarked: false,
                isMobile: false
            )
            ScrollView {
                if let html = bibleVM.verseRangeHTML {
                    HTMLText(htmlString: html)
                        .padding()
                        .background(AppColor.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                ForEach(bibleVM.verses) { verse in
                    Button {
                        selectedVerse = verse.verseNumber
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Verse \(verse.verseNumber ?? 0)")
                                .font(.caption)
                                .foregroundStyle(AppColor.textSecondary)
                            Text(verse.content ?? "")
                                .foregroundStyle(AppColor.textPrimary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppColor.surface.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
            }
            ChapterNavigationView(
                chapters: bibleVM.chapters,
                current: chapter,
                onSelect: { bibleVM.loadChapter(bookSlug: bookSlug, chapter: $0) }
            )
        }
        .padding()
        .navigationTitle("\(bookName) \(chapter)")
        .task {
            bibleVM.loadChapter(bookSlug: bookSlug, chapter: chapter, version: version)
        }
        .sheet(item: $selectedVerse) { verseNumber in
            VerseDetailScreen(bookSlug: bookSlug, bookName: bookName, chapter: chapter, verse: verseNumber, version: version)
        }
    }
}
```

### Screens/VerseDetailScreen.swift
```swift
struct VerseDetailScreen: View, Identifiable {
    let id = UUID()
    @StateObject private var viewModel = VerseDetailViewModel()
    let bookSlug: String
    let bookName: String
    let chapter: Int
    let verse: Int
    let version: String

    @State private var showCrossReferences = false
    @State private var showInterlinear = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VerseHeaderView(
                    verseText: viewModel.verseVersion?.content ?? "",
                    reference: "\(bookName) \(chapter):\(verse)",
                    version: version,
                    onFullChapter: {},
                    onBookmark: {},
                    onShare: {},
                    isLoading: viewModel.isLoading
                )

                StudyToggleGroup(
                    languageConfig: .init(label: "Interlinear", themeColor: AppColor.secondary, character: "א"),
                    isInterlinearOpen: showInterlinear,
                    isCrossReferencesOpen: showCrossReferences,
                    onToggleInterlinear: { showInterlinear.toggle() },
                    onToggleCrossReferences: { showCrossReferences.toggle() }
                )

                OverviewGrid(
                    verseReference: "\(bookName) \(chapter):\(verse)",
                    book: bookName,
                    bookOverview: viewModel.bookOverview,
                    verseTakeaways: viewModel.takeaways.first,
                    verseText: viewModel.verseVersion?.content ?? "",
                    verseVersion: version,
                    isLoading: viewModel.isLoading
                )

                CommentaryGrid(
                    verseReference: "\(bookName) \(chapter):\(verse)",
                    verseContent: viewModel.verseVersion?.content ?? "",
                    verseVersion: version
                )
            }
            .padding()
        }
        .onAppear {
            viewModel.load(bookSlug: bookSlug, chapter: chapter, verse: verse, version: version)
        }
        .sheet(isPresented: $showCrossReferences) {
            CrossReferenceDrawer(
                currentVerse: .init(book: bookSlug, chapter: chapter, verse: verse),
                version: version
            )
        }
        .sheet(isPresented: $showInterlinear) {
            InterlinearDrawer(currentVerse: .init(book: bookSlug, chapter: chapter, verse: verse, version: version))
        }
    }
}
```

### Screens/CommentatorsScreen.swift
```swift
struct CommentatorsScreen: View {
    @StateObject private var viewModel = CommentatorsViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("The Commentators")
                    .font(AppTypography.headingLarge)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if let error = viewModel.error {
                    Text(error.localizedDescription).foregroundColor(.red)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(viewModel.authors) { author in
                            NavigationLink {
                                AuthorScreen(author: author)
                            } label: {
                                AuthorCardView(author: author)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .task { await viewModel.loadAuthors() }
        .navigationTitle("Commentators")
    }
}
```

### Screens/AuthorScreen.swift
```swift
struct AuthorScreen: View {
    @StateObject private var viewModel = AuthorDetailViewModel()
    let author: Author

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                AuthorHeaderView(
                    author: author,
                    title: author.name,
                    subtitle: author.religiousTradition ?? "",
                    breadcrumbs: [
                        .init(label: "Commentators", destination: nil),
                        .init(label: author.name, destination: nil)
                    ]
                )

                Section(header: Text("Available Commentaries").font(.headline)) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 12)], spacing: 16) {
                        ForEach(viewModel.availableBooks) { book in
                            let available = viewModel.bookAvailability[book.slug] ?? true
                            NavigationLink {
                                AuthorBookPickerScreen(author: author, book: book)
                            } label: {
                                BookChip(title: book.name, isAvailable: available)
                            }
                            .disabled(!available)
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear { viewModel.hydrate(authorSlug: author.slug) }
        .navigationTitle(author.name)
    }
}
```

### Screens/BookmarksScreen.swift
```swift
struct BookmarksScreen: View {
    @EnvironmentObject private var viewModel: BookmarksViewModel
    @State private var token: String = ""

    var body: some View {
        VStack(spacing: 16) {
            BookmarkFiltersView(filters: $viewModel.filters)
            if viewModel.isLoading {
                ProgressView("Loading bookmarks…")
            } else {
                ForEach(viewModel.groups) { group in
                    Section {
                        ForEach(group.bookmarks) { bookmark in
                            BookmarkCardView(bookmark: bookmark) {
                                viewModel.deleteBookmark(bookmark.id)
                            }
                        }
                    } header: {
                        HStack {
                            Text(group.displayName).font(.headline)
                            Spacer()
                            ChipView(label: "\(group.count)", bgColor: .white.opacity(0.1), textColor: .white)
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Bookmarks")
        .task {
            if token.isEmpty {
                token = await AuthManager.shared.currentToken()
            }
            await viewModel.loadBookmarks(token: token)
        }
    }
}
```

### Screens/StrongsScreen.swift
```swift
struct StrongsScreen: View {
    @EnvironmentObject private var viewModel: StrongsViewModel
    @State private var inputKey: String = ""

    var body: some View {
        VStack(spacing: 16) {
            TextField("Enter Strong's key (e.g., H7225)", text: $inputKey)
                .textFieldStyle(.roundedBorder)
                .onSubmit { viewModel.loadEntry(key: inputKey) }
            if let entry = viewModel.entry {
                StrongsHeaderView(strongsData: entry, breadcrumbItems: [])
            }
            ScrollView {
                ForEach(viewModel.occurrences) { occurrence in
                    NavigationLink(destination: VerseDetailScreen(bookSlug: occurrence.book.lowercased().replacingOccurrences(of: " ", with: "-"), bookName: occurrence.book, chapter: occurrence.chapter, verse: occurrence.verse, version: APIConfiguration.shared.defaultVersion.uppercased())) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(occurrence.reference).font(.headline)
                            Text(occurrence.text).font(.body)
                        }
                        .padding()
                        .background(AppColor.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Strong's Lexicon")
    }
}
```

### Screens/SearchScreen.swift
```swift
struct SearchScreen: View {
    @EnvironmentObject private var viewModel: SearchViewModel
    @State private var query: String = ""

    var body: some View {
        VStack(spacing: 16) {
            TextField("Search verses, commentaries, authors…", text: $query)
                .textFieldStyle(.roundedBorder)
                .onSubmit { Task { await viewModel.submit(query: query) } }
            if viewModel.isSearching {
                ProgressView("Searching…")
            } else {
                List {
                    ForEach(viewModel.groups) { group in
                        Section(group.type) {
                            ForEach(group.entries) { entry in
                                VStack(alignment: .leading) {
                                    Text(entry.reference).font(.headline)
                                    Text(entry.text).font(.body).lineLimit(3)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .padding()
        .navigationTitle("Search")
    }
}
```

## ADDITIONAL SYSTEM CONSIDERATIONS

## TESTING & QUALITY STRATEGY
- **Unit Tests** – Cover `APIClient` request/response building, `VerseDetailViewModel`, `BookmarksViewModel`, `StrongsViewModel`, and `SearchViewModel` using fixtures based on the contracts in `src/types`.
- **Snapshot Tests** – Capture `VerseDetailScreen`, `CommentaryChapterScreen`, `StrongsScreen`, and `BookmarksScreen` to lock gradients, chips, and drawer states.
- **End-to-End** – Use XCUITest to validate Clerk login (ASWebAuthenticationSession + `scripturespot://auth/callback`), translations → book → chapter → verse navigation, lexicon lookup, and bookmark create/delete flows.

---

This markdown blueprint captures the Scripture Spot UI/UX, data contracts, service layer, MVVM structure, navigation, reusable components, theme tokens, and a compile-ready SwiftUI scaffold grounded entirely in the repository’s React/TypeScript implementation.
