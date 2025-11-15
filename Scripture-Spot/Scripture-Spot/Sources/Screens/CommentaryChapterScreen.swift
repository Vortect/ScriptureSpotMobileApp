import SwiftUI

struct CommentaryChapterScreen: View {
    let author: Author
    let book: BibleBookInfo
    let chapter: Int

    var body: some View {
        AuthorChapterScreen(author: author, book: book, chapter: chapter)
    }
}
