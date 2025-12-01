import SwiftUI

struct SpellListView: View {
    @StateObject private var viewModel = SpellListViewModel()

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading, .loaded:
                list
            case .empty(let message):
                StatePlaceholderView(kind: .empty, title: "No spells", message: message, actionTitle: "Reload") {
                    viewModel.refresh()
                }
            case .error(let message):
                StatePlaceholderView(kind: .error, title: "Unable to load spells", message: message, actionTitle: "Retry") {
                    viewModel.refresh()
                }
            }
        }
        .navigationTitle("Spells")
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
            ForEach(viewModel.items) { spell in
                NavigationLink(value: spell) {
                    SpellRowView(spell: spell)
                }
                .buttonStyle(.plain)
                .onAppear {
                    viewModel.loadMoreIfNeeded(current: spell)
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
        SpellListView()
    }
}
