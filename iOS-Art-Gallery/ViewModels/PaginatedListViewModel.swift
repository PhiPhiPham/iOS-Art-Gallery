import Combine
import Foundation

@MainActor
class PaginatedListViewModel<Item: Identifiable & Hashable>: ObservableObject {
    typealias FetchHandler = (_ page: Int, _ pageSize: Int) async throws -> PotterPage<Item>

    @Published private(set) var items: [Item] = []
    @Published private(set) var state: ViewState = .idle
    @Published private(set) var isLoadingMore = false
    @Published var alertMessage: String?
    @Published var isAlertVisible = false

    private var fetchHandler: FetchHandler
    private let pageSize: Int
    private var canLoadMore = true
    private var currentPage = 1
    private var loadTask: Task<Void, Never>?

    init(pageSize: Int, fetchHandler: @escaping FetchHandler) {
        self.pageSize = pageSize
        self.fetchHandler = fetchHandler
    }

    deinit {
        loadTask?.cancel()
    }

    func loadInitial() {
        guard items.isEmpty else { return }
        fetch(reset: true)
    }

    func refresh() {
        fetch(reset: true)
    }

    func refreshAsync() async {
        await MainActor.run {
            self.refresh()
        }
    }

    func loadMoreIfNeeded(current item: Item) {
        guard canLoadMore, !isLoadingMore, state == .loaded else { return }
        guard let last = items.last, last.id == item.id else { return }
        fetch(reset: false)
    }

    func updateFetchHandler(_ handler: @escaping FetchHandler, shouldReset: Bool = true) {
        fetchHandler = handler
        if shouldReset {
            fetch(reset: true)
        }
    }

    private func fetch(reset: Bool) {
        loadTask?.cancel()
        let pageToLoad: Int

        if reset {
            currentPage = 1
            canLoadMore = true
            items.removeAll()
            state = .loading
            pageToLoad = 1
        } else {
            isLoadingMore = true
            pageToLoad = currentPage + 1
        }

        let handler = fetchHandler

        loadTask = Task { [weak self] in
            guard let self else { return }
            do {
                let page = try await handler(pageToLoad, pageSize)
                await MainActor.run {
                    self.handleSuccess(page: page, reset: reset, pageLoaded: pageToLoad)
                }
            } catch {
                await MainActor.run {
                    self.handleFailure(error, reset: reset)
                }
            }
        }
    }

    private func handleSuccess(page: PotterPage<Item>, reset: Bool, pageLoaded: Int) {
        isLoadingMore = false
        canLoadMore = page.canLoadMore
        if reset {
            currentPage = 1
        } else {
            currentPage = pageLoaded
        }
        if reset {
            items = page.items
        } else {
            items.append(contentsOf: page.items)
        }
        state = items.isEmpty ? .empty(message: "Nothing to show right now.") : .loaded
    }

    private func handleFailure(_ error: Error, reset: Bool) {
        isLoadingMore = false
        let message: String
        if let localized = error as? LocalizedError, let description = localized.errorDescription {
            message = description
        } else {
            message = "Something unexpected happened. Please try again."
        }
        if reset || items.isEmpty {
            state = .error(message: message)
        }
        alertMessage = message
        isAlertVisible = true
    }
}
