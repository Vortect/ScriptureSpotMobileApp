import SwiftUI

struct OverviewGrid: View {
    let verseReference: String
    let book: String
    let bookOverview: BibleBookOverview?
    let verseTakeaway: VerseTakeaway?
    let verseText: String
    let verseVersion: String
    var isLoading: Bool

    var body: some View {
        VStack(spacing: 16) {
            if let overview = bookOverview {
                BookOverviewCard(overview: overview)
            }
            if let verseTakeaway {
                VerseTakeawaysCard(takeaway: verseTakeaway)
            }
            if isLoading {
                ProgressView()
                    .tint(AppColor.secondary)
            }
        }
    }
}
