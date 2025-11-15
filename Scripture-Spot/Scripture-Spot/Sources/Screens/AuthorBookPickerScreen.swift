import SwiftUI

struct AuthorBookPickerScreen: View {
    let author: Author
    let book: BibleBookInfo
    @StateObject private var viewModel = AuthorChapterViewModel()

    var body: some View {
        List {
            Section("Chapters") {
                ForEach(viewModel.chapters, id: \.self) { chapter in
                    let available = viewModel.chapterAvailability[chapter] ?? true
                    NavigationLink(
                        destination: AuthorChapterScreen(author: author, book: book, chapter: chapter)
                    ) {
                        HStack {
                            Text("Chapter \(chapter)")
                            Spacer()
                            if !available {
                                Text("Coming soon")
                                    .font(AppTypography.caption)
                                    .foregroundStyle(.orange)
                            }
                        }
                    }
                    .disabled(!available)
                }
            }
        }
        .navigationTitle(book.name)
        .task {
            await viewModel.loadChapters(bookSlug: book.slug)
            await viewModel.loadChapterAvailability(authorSlug: author.slug, bookSlug: book.slug, chapterNumbers: viewModel.chapters)
        }
    }
}
