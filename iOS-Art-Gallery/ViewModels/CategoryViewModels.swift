import Combine
import Foundation

@MainActor
final class BookListViewModel: PaginatedListViewModel<PotterBook> {
    init(service: PotterServicing = PotterService()) {
        super.init(pageSize: PotterCategory.books.defaultPageSize) { page, size in
            try await service.fetchBooks(page: page, pageSize: size)
        }
    }
}

@MainActor
final class MovieListViewModel: PaginatedListViewModel<PotterMovie> {
    init(service: PotterServicing = PotterService()) {
        super.init(pageSize: PotterCategory.movies.defaultPageSize) { page, size in
            try await service.fetchMovies(page: page, pageSize: size)
        }
    }
}

@MainActor
final class PotionListViewModel: PaginatedListViewModel<PotterPotion> {
    init(service: PotterServicing = PotterService()) {
        super.init(pageSize: PotterCategory.potions.defaultPageSize) { page, size in
            try await service.fetchPotions(page: page, pageSize: size)
        }
    }
}

@MainActor
final class SpellListViewModel: PaginatedListViewModel<PotterSpell> {
    init(service: PotterServicing = PotterService()) {
        super.init(pageSize: PotterCategory.spells.defaultPageSize) { page, size in
            try await service.fetchSpells(page: page, pageSize: size)
        }
    }
}

@MainActor
final class CharacterListViewModel: PaginatedListViewModel<PotterCharacter> {
    enum SortOrder: String, CaseIterable, Identifiable {
        case ascending = "A-Z"
        case descending = "Z-A"

        var id: String { rawValue }
        var isAscending: Bool { self == .ascending }
    }

    @Published var sortOrder: SortOrder = .ascending {
        didSet {
            guard oldValue != sortOrder else { return }
            configureFetchHandler()
        }
    }

    private let service: PotterServicing

    init(service: PotterServicing = PotterService()) {
        self.service = service
        super.init(pageSize: PotterCategory.characters.defaultPageSize) { page, size in
            try await service.fetchCharacters(page: page, pageSize: size, ascending: true)
        }
    }

    private func configureFetchHandler() {
        let ascending = sortOrder.isAscending
        updateFetchHandler({ [service] page, size in
            try await service.fetchCharacters(page: page, pageSize: size, ascending: ascending)
        })
    }
}
