import SwiftUI

struct VerseNavigationBar: View {
    var reference: String
    var onPrevious: () -> Void
    var onNext: () -> Void

    var body: some View {
        HStack {
            Button(action: onPrevious) {
                Label("Prev", systemImage: "chevron.left")
            }
            Spacer()
            Text(reference)
                .font(AppTypography.caption)
                .foregroundStyle(.white.opacity(0.8))
            Spacer()
            Button(action: onNext) {
                Label("Next", systemImage: "chevron.right")
                    .labelStyle(.titleAndIcon)
            }
        }
        .padding()
        .background(AppColor.surface.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
