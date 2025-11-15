import SwiftUI

enum AppColor {
    static let primary = Color(red: 0x27 / 255, green: 0x8E / 255, blue: 1.0)
    static let secondary = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let background = Color(red: 0x11 / 255, green: 0x11 / 255, blue: 0x11 / 255)
    static let surface = Color(red: 0x1A / 255, green: 0x1A / 255, blue: 0x1A / 255)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.6)
    static let chipBlue = Color(red: 0x96 / 255, green: 0xC2 / 255, blue: 0xFF / 255)
    static let gradientStart = Color(red: 0.58, green: 0.16, blue: 0.87)
    static let gradientEnd = Color(red: 0.09, green: 0.38, blue: 0.73)
}

enum AppTypography {
    static let headingLarge = Font.custom("Inter-Bold", size: 28)
    static let headingMedium = Font.custom("Inter-SemiBold", size: 23)
    static let body = Font.custom("Inter-Regular", size: 16)
    static let caption = Font.custom("Inter-Medium", size: 13)
}

enum AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

extension View {
    func cardStyle(cornerRadius: CGFloat = 28) -> some View {
        padding(AppSpacing.lg)
            .background(AppColor.surface.opacity(0.95))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(AppColor.textPrimary.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.35), radius: 24, y: 10)
    }

    func chipStyle(bg: Color = AppColor.primary.opacity(0.3), text: Color = AppColor.chipBlue) -> some View {
        padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.xs)
            .background(bg)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .foregroundStyle(text)
    }

    func gradientBackground(_ gradient: LinearGradient) -> some View {
        background(gradient)
            .clipShape(RoundedRectangle(cornerRadius: 35, style: .continuous))
    }
}

struct InterlinearTheme {
    static let hebrew = (drawerBg: Color(hex: "#221F19"), buttonActive: Color(hex: "#FFD700"))
    static let greek = (drawerBg: Color(hex: "#131820"), buttonActive: Color(hex: "#89B7F9"))
}

extension Color {
    init(hex: String) {
        var cleaned = hex
        if cleaned.hasPrefix("#") { cleaned.removeFirst() }
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)
        let r = Double((value >> 16) & 0xFF) / 255
        let g = Double((value >> 8) & 0xFF) / 255
        let b = Double(value & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
