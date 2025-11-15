import SwiftUI

struct BookmarkFiltersView: View {
    @Binding var filters: BookmarkFilters

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Search bookmarks", text: Binding(
                get: { filters.searchQuery },
                set: { filters.searchQuery = $0 }
            ))
            .textFieldStyle(.roundedBorder)

            Picker("Sort", selection: Binding(get: { filters.sortBy }, set: { filters.sortBy = $0 })) {
                ForEach(BookmarkSortOrder.allCases, id: \.self) { order in
                    Text(order.rawValue.capitalized).tag(order)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

struct BookChip: View {
    let title: String
    let isAvailable: Bool

    var body: some View {
        Text(title)
            .font(AppTypography.body)
            .frame(maxWidth: .infinity, minHeight: 70)
            .background(isAvailable ? AppColor.surface.opacity(0.9) : AppColor.surface.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isAvailable ? AppColor.secondary.opacity(0.4) : Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}
