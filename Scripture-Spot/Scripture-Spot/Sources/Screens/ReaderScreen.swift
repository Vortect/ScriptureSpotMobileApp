import SwiftUI

struct ReaderScreen: View {
    @StateObject private var viewModel = ReaderViewModel()
    let author: String
    let book: String
    let chapter: Int

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let chapter = viewModel.chapter {
                    Text(chapter.title)
                        .font(AppTypography.headingLarge)
                    HTMLText(htmlString: chapter.content)
                } else if viewModel.isLoading {
                    LoadStateView(text: "Loading chapter…")
                } else if let error = viewModel.error {
                    ErrorStateView(message: error.localizedDescription) {
                        Task { await viewModel.loadChapter(author: author, book: book, chapter: chapter) }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("\(book) \(chapter)")
        .task {
            await viewModel.loadChapter(author: author, book: book, chapter: chapter)
        }
    }
}
