//
//  GalleryViewModel.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import Combine
import Foundation

@MainActor
final class GalleryViewModel: ObservableObject {
    @Published private(set) var artworks: [Artwork] = []
    @Published private(set) var state: ViewState = .idle
    @Published private(set) var isLoadingMore = false
    @Published var searchText: String = ""
    @Published private(set) var yearRange: YearRange = .init()
    @Published var alertMessage: String?
    @Published var isAlertVisible = false

    private let service: ArtworkServicing
    private var canLoadMore = true
    private var query = ArtworkQuery()
    private var loadTask: Task<Void, Never>?
    private var searchDebounceTask: Task<Void, Never>?

    init(service: ArtworkServicing = ArtworkService()) {
        self.service = service
    }

    func loadInitial() {
        guard artworks.isEmpty else { return }
        fetch(reset: true)
    }

    func refresh() {
        fetch(reset: true)
    }

    func refreshAsync() async {
        await MainActor.run {
            refresh()
        }
    }

    func updateSearch(text: String) {
        searchText = text
        query.searchTerm = text
        debounceSearch()
    }

    func submitSearch() {
        searchDebounceTask?.cancel()
        fetch(reset: true)
    }

    func clearSearch() {
        guard !searchText.isEmpty else { return }
        searchText = ""
        query.searchTerm = ""
        fetch(reset: true)
    }

    func apply(yearRange: YearRange) {
        self.yearRange = yearRange
        query.yearRange = yearRange
        fetch(reset: true)
    }

    func clearYearFilter() {
        guard !yearRange.isEmpty else { return }
        apply(yearRange: YearRange())
    }

    func loadMoreIfNeeded(current artwork: Artwork) {
        guard canLoadMore, !isLoadingMore, state == .loaded else { return }
        guard let last = artworks.last, last.id == artwork.id else { return }
        query.page += 1
        fetch(reset: false)
    }

    private func fetch(reset: Bool) {
        loadTask?.cancel()
        if reset {
            query.resetPagination()
            canLoadMore = true
            if state != .loading {
                state = .loading
            }
            artworks.removeAll()
        } else {
            isLoadingMore = true
        }

        let currentQuery = query
        loadTask = Task { [weak self] in
            guard let self else { return }
            do {
                let page = try await service.fetchArtworks(query: currentQuery)
                await MainActor.run {
                    self.handleSuccess(page: page, reset: reset)
                }
            } catch {
                await MainActor.run {
                    self.handleFailure(error, reset: reset)
                }
            }
        }
    }

    private func handleSuccess(page: ArtworkPage, reset: Bool) {
        isLoadingMore = false
        canLoadMore = page.canLoadMore
        if reset {
            artworks = page.artworks
        } else {
            artworks.append(contentsOf: page.artworks)
        }

        if artworks.isEmpty {
            state = .empty(message: "No artworks matched your search. Try a different keyword or adjust the year filter.")
        } else {
            state = .loaded
        }
    }

    private func handleFailure(_ error: Error, reset: Bool) {
        isLoadingMore = false
        let message: String
        if let localized = error as? LocalizedError, let description = localized.errorDescription {
            message = description
        } else {
            message = "Something unexpected happened. Please try again."
        }
        if reset || artworks.isEmpty {
            state = .error(message: message)
        } else {
            state = .loaded
        }
        alertMessage = message
        isAlertVisible = true
    }

    private func debounceSearch() {
        searchDebounceTask?.cancel()
        searchDebounceTask = Task { [weak self] in
            do {
                try await Task.sleep(nanoseconds: 350_000_000)
                guard !Task.isCancelled, let self else { return }
                await MainActor.run {
                    self.fetch(reset: true)
                }
            } catch {
                // No-op
            }
        }
    }
}

#if DEBUG
extension GalleryViewModel {
    static func preview(artworks: [Artwork], state: ViewState) -> GalleryViewModel {
        let vm = GalleryViewModel()
        vm.artworks = artworks
        vm.state = state
        return vm
    }

    static var previewLoaded: GalleryViewModel {
        .preview(artworks: Array(repeating: PreviewData.sampleArtwork, count: 5), state: .loaded)
    }

    static var previewEmpty: GalleryViewModel {
        .preview(artworks: [], state: .empty(message: "Nothing matched your filters."))
    }
}
#endif
