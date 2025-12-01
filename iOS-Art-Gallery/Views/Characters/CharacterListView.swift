import SwiftUI

struct CharacterListView: View {
    @StateObject private var viewModel = CharacterListViewModel()

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading, .loaded:
                list
            case .empty(let message):
                StatePlaceholderView(kind: .empty, title: "No characters", message: message, actionTitle: "Reload") {
                    viewModel.refresh()
                }
            case .error(let message):
                StatePlaceholderView(kind: .error, title: "Unable to load characters", message: message, actionTitle: "Retry") {
                    viewModel.refresh()
                }
            }
        }
        .navigationTitle("Characters")
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
            Section {
                Picker("Sort order", selection: $viewModel.sortOrder) {
                    ForEach(CharacterListViewModel.SortOrder.allCases) { order in
                        Text(order.rawValue).tag(order)
                    }
                }
                .pickerStyle(.segmented)
            }

            ForEach(viewModel.items) { character in
                NavigationLink(value: character) {
                    CharacterRowView(character: character)
                }
                .buttonStyle(.plain)
                .onAppear {
                    viewModel.loadMoreIfNeeded(current: character)
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
        .listStyle(.insetGrouped)
        .refreshable {
            await viewModel.refreshAsync()
        }
    }
}

#Preview {
    NavigationStack {
        CharacterListView()
    }
}
