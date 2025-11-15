import SwiftUI

struct VerseDetailScreen: View, Identifiable {
    let id = UUID()

    let bookSlug: String
    let bookName: String
    let chapter: Int
    let verse: Int
    let version: String

    @StateObject private var viewModel = VerseDetailViewModel()
    @State private var showCrossReferences = false
    @State private var showInterlinear = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VerseHeaderView(
                    verseText: viewModel.verseVersion?.content ?? "",
                    reference: "\(bookName) \(chapter):\(verse)",
                    version: version,
                    isLoading: viewModel.isLoading,
                    onFullChapter: {},
                    onBookmark: {},
                    onShare: {}
                )

                StudyToggleGroup(
                    onToggleInterlinear: { showInterlinear.toggle() },
                    onToggleCrossReferences: { showCrossReferences.toggle() },
                    isInterlinearOpen: showInterlinear,
                    isCrossReferencesOpen: showCrossReferences
                )

                OverviewGrid(
                    verseReference: "\(bookName) \(chapter):\(verse)",
                    book: bookName,
                    bookOverview: viewModel.bookOverview,
                    verseTakeaway: viewModel.verseTakeaways.first,
                    verseText: viewModel.verseVersion?.content ?? "",
                    verseVersion: version,
                    isLoading: viewModel.isLoading
                )

                if let verseText = viewModel.verseVersion?.content {
                    CommentaryGrid(verseReference: "\(bookName) \(chapter):\(verse)", verseContent: verseText, verseVersion: version)
                }
            }
            .padding()
        }
        .background(AppColor.background)
        .navigationTitle("\(bookName) \(chapter):\(verse)")
        .task {
            await viewModel.loadVerse(bookSlug: bookSlug, chapter: chapter, verse: verse, version: version)
        }
        .sheet(isPresented: $showCrossReferences) {
            CrossReferenceDrawer(
                verseReference: "\(bookName) \(chapter):\(verse)",
                crossReferences: viewModel.crossReferences
            )
            .task {
                await viewModel.loadCrossReferences(bookSlug: bookSlug, chapter: chapter, verse: verse, version: version)
            }
        }
        .sheet(isPresented: $showInterlinear) {
            InterlinearDrawer(
                title: "Interlinear — \(bookName) \(chapter):\(verse)",
                words: viewModel.interlinearWords
            )
            .task {
                await viewModel.loadInterlinear(bookSlug: bookSlug, chapter: chapter, verse: verse)
            }
        }
    }
}
