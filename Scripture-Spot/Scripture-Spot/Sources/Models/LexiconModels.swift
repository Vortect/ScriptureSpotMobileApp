import Foundation

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
