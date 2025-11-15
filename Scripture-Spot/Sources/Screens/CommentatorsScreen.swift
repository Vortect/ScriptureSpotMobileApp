import SwiftUI

struct CommentatorsScreen: View {
    @StateObject private var viewModel = CommentatorsViewModel()

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 12)], spacing: 16) {
                ForEach(viewModel.authors) { author in
                    NavigationLink(destination: AuthorScreen(author: author)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(author.name)
                                .font(AppTypography.body)
                            Text(author.religiousTradition ?? "")
                                .font(AppTypography.caption)
                                .foregroundStyle(AppColor.textSecondary)
                        }
                        .padding()
                        .background(AppColor.surface.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Commentators")
        .task { await viewModel.loadAuthors() }
    }
}
