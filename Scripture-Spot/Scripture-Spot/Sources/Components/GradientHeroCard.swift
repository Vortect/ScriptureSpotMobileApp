import SwiftUI

struct GradientHeroCard: View {
    let title: String
    let description: String
    let gradient: LinearGradient
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(AppTypography.headingMedium)
                .foregroundStyle(.white)
            Text(description)
                .font(AppTypography.body)
                .foregroundStyle(.white.opacity(0.7))
            Spacer(minLength: 12)
            Button(actionTitle, action: action)
                .buttonStyle(.gradientCTA(gradient))
        }
        .frame(maxWidth: .infinity, minHeight: 180)
        .padding(20)
        .background(gradient.opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .strokeBorder(.white.opacity(0.15), lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.35), radius: 24, y: 10)
    }
}
