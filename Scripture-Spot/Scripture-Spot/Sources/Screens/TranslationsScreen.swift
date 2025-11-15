import SwiftUI

struct TranslationsScreen: View {
    @EnvironmentObject private var bibleVM: BibleNavigationViewModel

    var body: some View {
        List {
            Section("Versions") {
                ForEach(bibleVM.versions) { version in
                    NavigationLink(destination: BibleBooksScreen(versionSlug: version.code.lowercased())) {
                        VStack(alignment: .leading) {
                            Text(version.title)
                                .font(.headline)
                            Text(version.description ?? version.language)
                                .font(.subheadline)
                                .foregroundStyle(AppColor.textSecondary)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Translations")
        .task {
            await bibleVM.loadVersions()
        }
    }
}
