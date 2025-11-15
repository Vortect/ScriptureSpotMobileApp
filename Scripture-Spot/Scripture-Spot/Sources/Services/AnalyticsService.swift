import Foundation

protocol AnalyticsService {
    func trackScreen(name: String)
    func trackVerseOpen(book: String, chapter: Int, verse: Int)
    func trackLexiconKey(_ key: String)
    func trackBookmark(action: String, contentId: String)
}

struct AnalyticsManager: AnalyticsService {
    static let shared = AnalyticsManager()

    func trackScreen(name: String) {
        debugPrint("[Analytics] Screen: \(name)")
    }

    func trackVerseOpen(book: String, chapter: Int, verse: Int) {
        debugPrint("[Analytics] Verse Open: \(book) \(chapter):\(verse)")
    }

    func trackLexiconKey(_ key: String) {
        debugPrint("[Analytics] Strong's lookup: \(key)")
    }

    func trackBookmark(action: String, contentId: String) {
        debugPrint("[Analytics] Bookmark \(action) for id \(contentId)")
    }
}
