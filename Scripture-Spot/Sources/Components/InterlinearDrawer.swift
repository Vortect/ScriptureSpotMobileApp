import SwiftUI

struct InterlinearDrawer: View {
    let title: String
    let words: [InterlinearWord]

    var body: some View {
        NavigationStack {
            List(words) { word in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(word.englishWord)
                            .font(AppTypography.body)
                        Spacer()
                        Text(word.strongsKey)
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColor.secondary)
                    }
                    Text(word.transliteration)
                        .font(.subheadline)
                        .foregroundStyle(AppColor.textSecondary)
                    Text(word.grammarDetailed)
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
                .padding(8)
                .background(AppColor.surface.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .scrollContentBackground(.hidden)
            .background(AppColor.background)
            .navigationTitle(title)
        }
    }
}
