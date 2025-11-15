import SwiftUI

struct VerseTakeawaysCard: View {
    let takeaway: VerseTakeaway

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Key Takeaway")
                .font(AppTypography.caption)
                .foregroundStyle(AppColor.textSecondary)
            if let excerpt = takeaway.excerpts?.first {
                Text(excerpt.title ?? "")
                    .font(AppTypography.headingMedium)
                Text(excerpt.content ?? "")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColor.textSecondary)
            }
            if let quote = takeaway.quotes?.first {
                Divider().background(.white.opacity(0.2))
                Text("\(quote.author?.name ?? "") — \(quote.title ?? "")")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.textSecondary)
                Text(quote.content ?? "")
                    .font(.callout)
                    .italic()
            }
        }
        .cardStyle()
    }
}
