import SwiftUI

struct AuthorScreen: View {
    let author: Author
    @StateObject private var viewModel = AuthorDetailViewModel()

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

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 16)], spacing: 16) {
                    ForEach(viewModel.availableBooks) { book in
                        let available = viewModel.bookAvailability[book.slug] ?? true
                        NavigationLink(destination: AuthorBookPickerScreen(author: author, book: book)) {
                            BookChip(title: book.name, isAvailable: available)
                        }
                        .disabled(!available)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(author.name)
        .task {
            await viewModel.hydrate(authorSlug: author.slug)
            await viewModel.loadAvailability(for: author.slug, books: viewModel.availableBooks.map(\.slug))
        }
    }
}
