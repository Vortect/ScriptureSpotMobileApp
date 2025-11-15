import SwiftUI

struct StudyToggleGroup: View {
    let onToggleInterlinear: () -> Void
    let onToggleCrossReferences: () -> Void
    var isInterlinearOpen: Bool
    var isCrossReferencesOpen: Bool

    var body: some View {
        HStack(spacing: 12) {
            ToggleButton(title: "Interlinear", isOn: isInterlinearOpen, action: onToggleInterlinear)
            ToggleButton(title: "Cross References", isOn: isCrossReferencesOpen, action: onToggleCrossReferences)
        }
    }

    private struct ToggleButton: View {
        let title: String
        var isOn: Bool
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                Text(title)
                    .font(AppTypography.caption)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(isOn ? AppColor.secondary.opacity(0.2) : AppColor.surface.opacity(0.7))
                    .clipShape(Capsule())
                    .foregroundStyle(isOn ? AppColor.secondary : AppColor.textPrimary)
            }
        }
    }
}
