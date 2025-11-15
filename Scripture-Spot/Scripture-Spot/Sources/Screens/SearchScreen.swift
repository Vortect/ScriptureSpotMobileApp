import SwiftUI

struct SearchScreen: View {
    @EnvironmentObject private var viewModel: SearchViewModel
    @State private var query: String = ""

    var body: some View {
        VStack(spacing: 16) {
            TextField("Search verses, commentaries, authors…", text: $query)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)
                .onSubmit { Task { await viewModel.submit(query: query) } }

            if viewModel.isSearching {
                LoadStateView(text: "Searching…")
            } else {
                List {
                    ForEach(viewModel.groups) { group in
                        Section(group.type) {
                            ForEach(group.entries) { entry in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(entry.reference)
                                        .font(.headline)
                                    Text(entry.text)
                                        .font(.body)
                                        .lineLimit(3)
                                        .foregroundStyle(AppColor.textSecondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .padding()
        .navigationTitle("Search")
    }
}
