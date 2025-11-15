import SwiftUI

struct VerseTakeawaysScreen: View {
    @StateObject private var viewModel = VerseTakeawaysViewModel()
    let bookSlug: String
    let chapter: Int
    let version: String

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.takeawaysByVerse.keys.sorted(), id: \.self) { verse in
                    if let takeaway = viewModel.takeawaysByVerse[verse] {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Verse \(verse)")
                                .font(AppTypography.caption)
                            VerseTakeawaysCard(takeaway: takeaway)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Takeaways — \(chapter)")
        .task {
            await viewModel.loadChapter(bookSlug: bookSlug, chapter: chapter, version: version)
        }
    }
}
