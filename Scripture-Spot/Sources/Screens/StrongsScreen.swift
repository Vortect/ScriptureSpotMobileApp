import SwiftUI

struct StrongsScreen: View {
    @EnvironmentObject private var viewModel: StrongsViewModel
    @State private var key: String = ""

    var body: some View {
        VStack(spacing: 16) {
            TextField("Enter Strong's key", text: $key)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)
                .onSubmit { Task { await viewModel.loadEntry(key: key) } }

            if viewModel.isLoading {
                LoadStateView(text: "Searching…")
            }

            if let entry = viewModel.entry {
                StrongsHeaderView(entry: entry)
            }

            List(viewModel.occurrences) { occurrence in
                VStack(alignment: .leading, spacing: 4) {
                    Text(occurrence.reference)
                        .font(.headline)
                    Text(occurrence.text)
                        .font(.body)
                        .foregroundStyle(AppColor.textSecondary)
                }
                .padding(.vertical, 4)
            }
            .listStyle(.plain)
        }
        .padding()
        .navigationTitle("Strong's")
    }
}

struct StrongsHeaderView: View {
    let entry: StrongsLexiconEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.strongsKey ?? "")
                .font(AppTypography.headingLarge)
            Text(entry.shortDefinition ?? "")
                .font(AppTypography.body)
            if let translation = entry.kjvTranslation {
                Text("KJV: \(translation)")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.textSecondary)
            }
        }
        .cardStyle()
    }
}
