import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var homeVM: HomeViewModel
    @EnvironmentObject private var bibleVM: BibleNavigationViewModel
    @EnvironmentObject private var bookmarksVM: BookmarksViewModel
    @EnvironmentObject private var searchVM: SearchViewModel
    @EnvironmentObject private var strongsVM: StrongsViewModel

    var body: some View {
        TabView {
            NavigationStack {
                HomeScreen()
            }
            .tabItem { Label("Study", systemImage: "house") }

            NavigationStack {
                TranslationsScreen()
            }
            .tabItem { Label("Read", systemImage: "book.closed") }

            NavigationStack {
                CommentatorsScreen()
            }
            .tabItem { Label("Commentary", systemImage: "person.3") }

            NavigationStack {
                BookmarksScreen()
            }
            .tabItem { Label("Library", systemImage: "bookmark") }

            NavigationStack {
                StrongsScreen()
            }
            .tabItem { Label("Lexicon", systemImage: "character.book.closed") }

            NavigationStack {
                SearchScreen()
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
        }
        .tint(AppColor.secondary)
        .background(AppColor.background.ignoresSafeArea())
        .onAppear {
            Task {
                await homeVM.loadVerseOfTheDay(version: APIConfiguration.shared.defaultVersion.uppercased())
                await bibleVM.loadBooks()
                await bibleVM.loadVersions()
            }
        }
    }
}
