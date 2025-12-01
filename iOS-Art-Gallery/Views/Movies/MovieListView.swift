import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading, .loaded:
                list
            case .empty(let message):
                StatePlaceholderView(kind: .empty, title: "No movies", message: message, actionTitle: "Reload") {
                    viewModel.refresh()
                }
            case .error(let message):
                StatePlaceholderView(kind: .error, title: "Unable to load movies", message: message, actionTitle: "Retry") {
                    viewModel.refresh()
                }
            }
        }
        .navigationTitle("Movies")
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
            ForEach(viewModel.items) { movie in
                NavigationLink(value: movie) {
                    MovieRowView(movie: movie)
                }
                .buttonStyle(.plain)
                .onAppear {
                    viewModel.loadMoreIfNeeded(current: movie)
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
        MovieListView()
    }
}
