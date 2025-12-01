import SwiftUI

struct BookListView: View {
    @StateObject private var viewModel = BookListViewModel()

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading, .loaded:
                list
            case .empty(let message):
                StatePlaceholderView(kind: .empty, title: "No books", message: message, actionTitle: "Reload") {
                    viewModel.refresh()
                }
            case .error(let message):
                StatePlaceholderView(kind: .error, title: "Unable to load books", message: message, actionTitle: "Retry") {
                    viewModel.refresh()
                }
            }
        }
        .navigationTitle("Books")
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
            ForEach(viewModel.items) { book in
                NavigationLink(value: book) {
                    BookRowView(book: book)
                }
                .buttonStyle(.plain)
                .onAppear {
                    viewModel.loadMoreIfNeeded(current: book)
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
        BookListView()
    }
}
