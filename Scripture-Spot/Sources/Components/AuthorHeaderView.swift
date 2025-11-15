import SwiftUI

struct AuthorHeaderView: View {
    struct Breadcrumb: Identifiable {
        let id = UUID()
        let label: String
        let destination: (() -> Void)?
    }

    let author: Author
    let title: String
    let subtitle: String
    let breadcrumbs: [Breadcrumb]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(Array(breadcrumbs.enumerated()), id: \.element.id) { index, crumb in
                        if let destination = crumb.destination {
                            Button(action: destination) {
                                Text(crumb.label)
                                    .font(AppTypography.caption)
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                        } else {
                            Text(crumb.label)
                                .font(AppTypography.caption)
                                .foregroundStyle(.white)
                        }
                        if index < breadcrumbs.count - 1 {
                            Image(systemName: "chevron.right")
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                }
            }

            Text(title)
                .font(AppTypography.headingLarge)
                .foregroundStyle(.white)

            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(AppTypography.body)
                    .foregroundStyle(.white.opacity(0.7))
            }

            HStack(spacing: 12) {
                if let imageURL = author.image, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.white.opacity(0.05)
                    }
                    .frame(width: 96, height: 96)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }

                VStack(alignment: .leading, spacing: 8) {
                    if let years = author.years {
                        ChipView(label: years)
                    }
                    if let tradition = author.religiousTradition {
                        ChipView(label: tradition)
                    }
                }
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color(hex: author.colorScheme?.primary ?? "#5B41DE"), .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .strokeBorder(.white.opacity(0.15), lineWidth: 1)
        )
    }
}
