import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject private var viewModel: HomeViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                GradientHeroCard(
                    title: "Verse of the Day",
                    description: viewModel.verseOfTheDay?.text ?? "Load a daily encouragement",
                    gradient: LinearGradient(colors: [AppColor.gradientStart, AppColor.gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing),
                    actionTitle: "Open"
                ) {}

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    GradientHeroCard(
                        title: "Continue Reading",
                        description: viewModel.lastVerseReference ?? "Pick up where you left off",
                        gradient: LinearGradient(colors: [AppColor.primary, AppColor.primary.opacity(0.3)], startPoint: .leading, endPoint: .trailing),
                        actionTitle: "Resume"
                    ) {}

                    GradientHeroCard(
                        title: "Explore Commentaries",
                        description: "Meet trusted voices",
                        gradient: LinearGradient(colors: [AppColor.secondary, AppColor.primary], startPoint: .top, endPoint: .bottom),
                        actionTitle: "Open"
                    ) {}
                }
            }
            .padding()
        }
        .background(AppColor.background)
        .onAppear {
            viewModel.restoreLastActivity()
        }
    }
}
