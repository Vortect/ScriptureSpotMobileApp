import SwiftUI
import UIKit

@main
struct ScriptureSpotApp: App {
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var bibleNavigationViewModel = BibleNavigationViewModel()
    @StateObject private var bookmarksViewModel = BookmarksViewModel()
    @StateObject private var searchViewModel = SearchViewModel()
    @StateObject private var strongsViewModel = StrongsViewModel()
    @StateObject private var sessionManager = SessionManager.shared

    init() {
        UIView.appearance().tintColor = UIColor(AppColor.secondary)
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(homeViewModel)
                .environmentObject(bibleNavigationViewModel)
                .environmentObject(bookmarksViewModel)
                .environmentObject(searchViewModel)
                .environmentObject(strongsViewModel)
                .environmentObject(sessionManager)
                .background(AppColor.background.ignoresSafeArea())
        }
    }
}
