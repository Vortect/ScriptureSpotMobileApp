import Foundation

struct VerseIdentifier: Identifiable, Hashable {
    let book: String
    let chapter: Int
    let verse: Int
    let version: String?
    var id: String { "\(book)-\(chapter)-\(verse)-\(version ?? "")" }
}
