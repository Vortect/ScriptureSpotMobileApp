import SwiftUI
import UIKit

struct VerseHeaderView: View {
    let verseText: String
    let reference: String
    let version: String
    var isLoading: Bool
    var onFullChapter: () -> Void
    var onBookmark: () -> Void
    var onShare: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if isLoading {
                ProgressView()
                    .tint(AppColor.secondary)
            }
            Text(reference)
                .font(AppTypography.caption)
                .foregroundStyle(AppColor.textSecondary)
            Text(verseText)
                .font(AppTypography.headingLarge)
            Text(version.uppercased())
                .font(AppTypography.caption)
                .foregroundStyle(AppColor.textSecondary)
            VerseActionsBar(
                onBookmark: onBookmark,
                onShare: onShare,
                onCopy: { UIPasteboard.general.string = verseText },
                onFullChapter: onFullChapter,
                isBookmarked: false
            )
        }
        .cardStyle()
    }
}
