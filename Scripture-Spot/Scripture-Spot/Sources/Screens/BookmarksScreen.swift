import SwiftUI

struct BookmarksScreen: View {
    @EnvironmentObject private var viewModel: BookmarksViewModel
    @EnvironmentObject private var sessionManager: SessionManager

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                BookmarkFiltersView(filters: $viewModel.filters)
                if viewModel.isLoading {
                    LoadStateView(text: "Loading bookmarks…")
                } else if let error = viewModel.error {
                    ErrorStateView(message: error.localizedDescription) {
                        Task { await reload() }
                    }
                } else {
                    ForEach(viewModel.groups) { group in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(group.displayName)
                                    .font(AppTypography.headingMedium)
                                Spacer()
                                ChipView(label: "\(group.count)")
                            }
                            ForEach(group.bookmarks) { bookmark in
                                BookmarkCardView(display: bookmark) {
                                    Task { await viewModel.deleteBookmark(bookmark.id) }
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Bookmarks")
        .task { await reload() }
    }

    private func reload() async {
        if !sessionManager.isAuthenticated {
            sessionManager.loadPersistedSession()
        }
        if let token = sessionManager.currentToken {
            await viewModel.loadBookmarks(token: token)
        }
    }
}
