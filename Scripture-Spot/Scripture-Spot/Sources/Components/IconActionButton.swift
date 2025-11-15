import SwiftUI

enum AppIcon: String {
    case bookmark = "bookmark"
    case share = "square.and.arrow.up"
    case copy = "doc.on.doc"
    case book = "book"
    case magnifyingGlass = "magnifyingglass"

    var image: Image {
        Image(systemName: rawValue)
    }
}

struct IconActionButton: View {
    let icon: AppIcon
    let label: String
    let action: () -> Void
    var isActive: Bool = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                icon.image
                    .font(.title3)
                Text(label)
                    .font(AppTypography.caption)
            }
            .foregroundStyle(isActive ? AppColor.secondary : AppColor.textPrimary)
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(AppColor.surface.opacity(isActive ? 0.8 : 0.4))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}
