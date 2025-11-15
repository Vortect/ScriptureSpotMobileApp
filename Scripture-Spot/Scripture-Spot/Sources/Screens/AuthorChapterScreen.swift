import SwiftUI

struct AuthorChapterScreen: View {
    let author: Author
    let book: BibleBookInfo
    let chapter: Int
    @StateObject private var viewModel = ChapterCommentaryViewModel()

    var body: some View {
        List {
            Section("Version") {
                Picker("Version", selection: $viewModel.selectedVersion) {
                    Text("Default").tag(viewModel.selectedVersion)
                    Text("ASV").tag("ASV")
                }
                .pickerStyle(.segmented)
            }

            ForEach(viewModel.groupedCommentaries) { group in
                Section("Verse \(group.verse)") {
                    ForEach(group.commentaries) { commentary in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(commentary.author?.name ?? author.name)
                                .font(.headline)
                            Text(commentary.previewContent ?? "")
                                .font(.body)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("\(author.name) — \(book.name) \(chapter)")
        .task {
            await viewModel.loadChapter(authorSlug: author.slug, bookSlug: book.slug, chapter: chapter)
        }
    }
}
