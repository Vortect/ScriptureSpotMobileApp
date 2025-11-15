import SwiftUI

struct BibleChapterScreen: View {
    @EnvironmentObject private var bibleVM: BibleNavigationViewModel
    @StateObject private var chapterVM = BibleChapterViewModel()
    @State private var selectedVerse: BibleVerseVersion?

    let bookSlug: String
    let bookName: String
    let chapter: Int
    let version: String

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let html = chapterVM.verseRangeHTML {
                    HTMLText(htmlString: html)
                        .cardStyle(cornerRadius: 20)
                }
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(chapterVM.verses) { verse in
                        Button {
                            selectedVerse = verse
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Verse \(verse.verseNumber ?? 0)")
                                    .font(AppTypography.caption)
                                    .foregroundStyle(AppColor.textSecondary)
                                Text(verse.content ?? "")
                                    .font(AppTypography.body)
                                    .foregroundStyle(AppColor.textPrimary)
                            }
                            .padding()
                            .background(AppColor.surface.opacity(0.9))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                    }
                }
                ChapterNavigationView(chapters: bibleVM.chapters, current: chapter) { chapter in
                    Task { await chapterVM.loadChapter(bookSlug: bookSlug, chapter: chapter) }
                }
            }
            .padding()
        }
        .navigationTitle("\(bookName) \(chapter)")
        .task {
            await bibleVM.loadChapters(for: bookSlug)
            await chapterVM.loadChapter(bookSlug: bookSlug, chapter: chapter)
        }
        .sheet(item: $selectedVerse) { verse in
            VerseDetailScreen(bookSlug: bookSlug, bookName: bookName, chapter: chapter, verse: verse.verseNumber ?? 1, version: version)
        }
    }
}
