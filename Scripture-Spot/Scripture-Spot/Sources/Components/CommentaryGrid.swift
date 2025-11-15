import SwiftUI

struct CommentaryGrid: View {
    let verseReference: String
    let verseContent: String
    let verseVersion: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Commentary Preview")
                .font(AppTypography.headingMedium)
            Text("\(verseReference) — \(verseVersion)")
                .font(AppTypography.caption)
                .foregroundStyle(AppColor.textSecondary)
            Text(verseContent)
                .font(AppTypography.body)
        }
        .cardStyle()
    }
}
