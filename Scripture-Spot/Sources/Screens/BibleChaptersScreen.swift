import SwiftUI

struct BibleChaptersScreen: View {
    @EnvironmentObject private var bibleVM: BibleNavigationViewModel
    let bookSlug: String
    let bookName: String
    let versionSlug: String

    var body: some View {
        Group {
            if bibleVM.isLoading {
                LoadStateView(text: "Loading chapters")
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 12) {
                        ForEach(bibleVM.chapters, id: \.self) { chapter in
                            NavigationLink(
                                destination: BibleChapterScreen(bookSlug: bookSlug, bookName: bookName, chapter: chapter, version: versionSlug)
                            ) {
                                Text("\(chapter)")
                                    .frame(maxWidth: .infinity, minHeight: 60)
                                    .background(AppColor.surface.opacity(0.9))
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(bookName)
        .task {
            await bibleVM.loadChapters(for: bookSlug)
        }
    }
}
