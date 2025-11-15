import SwiftUI

struct BibleBooksScreen: View {
    @EnvironmentObject private var bibleVM: BibleNavigationViewModel
    let versionSlug: String

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 16) {
                ForEach(bibleVM.books) { book in
                    NavigationLink(destination: BibleChaptersScreen(bookSlug: book.slug, bookName: book.name, versionSlug: versionSlug)) {
                        Text(book.name)
                            .font(AppTypography.body)
                            .frame(maxWidth: .infinity, minHeight: 80)
                            .background(AppColor.surface.opacity(0.9))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                }
            }
            .padding()
        }
        .navigationTitle(versionSlug.uppercased())
        .task {
            await bibleVM.loadBooks()
        }
    }
}
