import SwiftUI

struct PotionListView: View {
    @StateObject private var viewModel = PotionListViewModel()

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading, .loaded:
                list
            case .empty(let message):
                StatePlaceholderView(kind: .empty, title: "No potions", message: message, actionTitle: "Reload") {
                    viewModel.refresh()
                }
            case .error(let message):
                StatePlaceholderView(kind: .error, title: "Unable to load potions", message: message, actionTitle: "Retry") {
                    viewModel.refresh()
                }
            }
        }
        .navigationTitle("Potions")
        .alert("Potter Wiki", isPresented: $viewModel.isAlertVisible) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage ?? "")
        }
        .task {
            viewModel.loadInitial()
        }
    }

    private var list: some View {
        List {
            ForEach(viewModel.items) { potion in
                NavigationLink(value: potion) {
                    PotionRowView(potion: potion)
                }
                .buttonStyle(.plain)
                .onAppear {
                    viewModel.loadMoreIfNeeded(current: potion)
                }
            }
            if viewModel.isLoadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.refreshAsync()
        }
    }
}

#Preview {
    NavigationStack {
        PotionListView()
    }
}
