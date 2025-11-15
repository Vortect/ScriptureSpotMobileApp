import SwiftUI

struct BookmarkCardView: View {
    let display: BookmarkDisplay
    var onDelete: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(display.bookmark.title)
                    .font(AppTypography.headingMedium)
                Spacer()
                if let onDelete {
                    Button(role: .destructive, action: onDelete) {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(.borderless)
                }
            }
            if let reference = display.formattedReference {
                Text(reference)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.textSecondary)
            }
            if let excerpt = display.excerpt {
                Text(excerpt)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColor.textPrimary)
            }
            if let tags = display.displayTags, !tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack { ForEach(tags, id: \.self) { ChipView(label: $0) } }
                }
            }
        }
        .cardStyle()
    }
}
