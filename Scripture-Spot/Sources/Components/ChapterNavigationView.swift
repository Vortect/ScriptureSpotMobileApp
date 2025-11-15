import SwiftUI

struct ChapterNavigationView: View {
    let chapters: [Int]
    let current: Int
    var onSelect: (Int) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(chapters, id: \.self) { chapter in
                    Button(action: { onSelect(chapter) }) {
                        Text("\(chapter)")
                            .font(AppTypography.caption)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(chapter == current ? AppColor.secondary.opacity(0.2) : AppColor.surface.opacity(0.6))
                            .clipShape(Capsule())
                            .foregroundStyle(chapter == current ? AppColor.secondary : AppColor.textPrimary)
                    }
                }
            }
        }
    }
}
