import SwiftUI

struct ChipView: View {
    let label: String
    var bgColor: Color = AppColor.surface.opacity(0.8)
    var textColor: Color = .white
    var systemImage: String?

    var body: some View {
        HStack(spacing: 6) {
            if let systemImage {
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
            }
            Text(label)
                .font(AppTypography.caption)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(bgColor)
        .clipShape(Capsule())
        .foregroundStyle(textColor)
    }
}
