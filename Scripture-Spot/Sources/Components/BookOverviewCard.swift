import SwiftUI

struct BookOverviewCard: View {
    let overview: BibleBookOverview

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(overview.bibleBook?.name ?? "Book Overview")
                .font(AppTypography.headingMedium)
            if let author = overview.author {
                ChipView(label: "Author: \(author)", systemImage: "person")
            }
            if let audience = overview.audience {
                Text("Audience: \(audience)")
            }
            if let keyThemes = overview.keyThemes {
                Text(keyThemes)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColor.textSecondary)
            }
        }
        .cardStyle()
    }
}
