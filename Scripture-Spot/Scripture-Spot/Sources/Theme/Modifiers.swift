import SwiftUI

struct GradientCTAStyle: ButtonStyle {
    let gradient: LinearGradient

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.body.weight(.semibold))
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(gradient)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.8 : 1)
            .shadow(color: .black.opacity(0.25), radius: 12, y: 6)
    }
}

extension ButtonStyle where Self == GradientCTAStyle {
    static func gradientCTA(_ gradient: LinearGradient) -> GradientCTAStyle {
        GradientCTAStyle(gradient: gradient)
    }
}

extension View {
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        modifier(PressEventsModifier(onPress: onPress, onRelease: onRelease))
    }
}

private struct PressEventsModifier: ViewModifier {
    let onPress: () -> Void
    let onRelease: () -> Void

    func body(content: Content) -> some View {
        content.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in onPress() }
                .onEnded { _ in onRelease() }
        )
    }
}
