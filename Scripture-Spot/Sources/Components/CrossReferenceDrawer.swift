import SwiftUI

struct CrossReferenceDrawer: View {
    let verseReference: String
    let crossReferences: [CrossReferenceKeyword]

    var body: some View {
        NavigationStack {
            List {
                ForEach(crossReferences) { keyword in
                    Section(keyword.keyword) {
                        ForEach(keyword.bibleVerseReferences, id: \.slug) { reference in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(reference.label)
                                    .font(.headline)
                                Text(reference.text)
                                    .font(.body)
                                    .foregroundStyle(AppColor.textSecondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppColor.background)
            .navigationTitle("Cross References — \(verseReference)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Text("Swipe down to dismiss")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColor.textSecondary)
                }
            }
        }
    }
}
