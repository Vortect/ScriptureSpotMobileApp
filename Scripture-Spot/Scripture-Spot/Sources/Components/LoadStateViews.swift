import SwiftUI

struct LoadStateView: View {
    var text: String

    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .tint(AppColor.secondary)
            Text(text)
                .font(AppTypography.body)
        }
        .padding()
    }
}

struct ErrorStateView: View {
    var message: String
    var retry: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
                .font(.largeTitle)
            Text(message)
                .multilineTextAlignment(.center)
            if let retry {
                Button("Retry", action: retry)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}
