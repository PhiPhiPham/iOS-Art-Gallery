import SwiftUI

@MainActor
struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                Text("Today's recommendation")
                    .font(.title3.bold())
                recommendationSection
                Text("Explore the universe")
                    .font(.title3.bold())
                menuGrid
            }
            .padding()
        }
        .alert("Potter Wiki", isPresented: $viewModel.isAlertVisible) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage ?? "")
        }
        .task {
            viewModel.loadIfNeeded()
        }
    }

    @ViewBuilder
    private var recommendationSection: some View {
        switch viewModel.recommendationState {
        case .idle, .loading:
            PlaceholderRecommendationView(isLoading: viewModel.recommendationState == .loading)
        case .error(let message):
            StatePlaceholderView(kind: .error, title: "Unable to load", message: message, actionTitle: "Retry") {
                viewModel.fetchRecommendation()
            }
            .frame(maxWidth: .infinity)
        case .empty(let message):
            StatePlaceholderView(kind: .empty, title: "No suggestion", message: message.isEmpty ? "We'll have a new pick for you soon." : message)
                .frame(maxWidth: .infinity)
        case .loaded:
            if let recommendation = viewModel.recommendation {
                recommendationLink(for: recommendation)
            } else {
                PlaceholderRecommendationView(isLoading: false)
            }
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            Text("Potter Wiki")
                .font(.largeTitle.bold())
            Spacer()
            Button {
                viewModel.fetchRecommendation()
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
                    .labelStyle(.iconOnly)
                    .font(.title3)
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
    }

    @ViewBuilder
    private func recommendationLink(for recommendation: PotterRecommendation) -> some View {
        switch recommendation {
        case .book(let book):
            NavigationLink(value: book) {
                RecommendationCard(recommendation: recommendation)
            }
            .buttonStyle(.plain)
        case .movie(let movie):
            NavigationLink(value: movie) {
                RecommendationCard(recommendation: recommendation)
            }
            .buttonStyle(.plain)
        case .character(let character):
            NavigationLink(value: character) {
                RecommendationCard(recommendation: recommendation)
            }
            .buttonStyle(.plain)
        case .potion(let potion):
            NavigationLink(value: potion) {
                RecommendationCard(recommendation: recommendation)
            }
            .buttonStyle(.plain)
        case .spell(let spell):
            NavigationLink(value: spell) {
                RecommendationCard(recommendation: recommendation)
            }
            .buttonStyle(.plain)
        }
    }

    private var menuGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(viewModel.menuItems) { category in
                NavigationLink(value: category) {
                    CategoryMenuCard(category: category)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct PlaceholderRecommendationView: View {
    let isLoading: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .frame(height: 140)
                .overlay {
                    if isLoading {
                        ProgressView("Fetching today's pick…")
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                            Text("We're conjuring a surprise for you")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        HomeView(viewModel: PreviewData.homeViewModel)
    }
}
