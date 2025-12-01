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
    enum LetterGroup: String, CaseIterable, Identifiable {
        case all = "All"
        case aToC = "A-C"
        case dToF = "D-F"
        case gToI = "G-I"
        case jToL = "J-L"
        case mToO = "M-O"
        case pToR = "P-R"
        case sToU = "S-U"
        case vToZ = "V-Z"

        var id: String { rawValue }

        private var bounds: (Character, Character)? {
            switch self {
            case .all: return nil
            case .aToC: return ("A", "C")
            case .dToF: return ("D", "F")
            case .gToI: return ("G", "I")
            case .jToL: return ("J", "L")
            case .mToO: return ("M", "O")
            case .pToR: return ("P", "R")
            case .sToU: return ("S", "U")
            case .vToZ: return ("V", "Z")
            }
        }

        func contains(_ name: String) -> Bool {
            guard let (lower, upper) = bounds else { return true }
            guard let first = name.trimmingCharacters(in: .whitespacesAndNewlines).first else { return false }
            let uppercased = Character(String(first).uppercased())
            let isLetter = uppercased.unicodeScalars.allSatisfy { CharacterSet.letters.contains($0) }
            guard isLetter else { return false }
            return uppercased >= lower && uppercased <= upper
        }
    }

    @Published var letterGroup: LetterGroup = .all

    var filteredCharacters: [PotterCharacter] {
        items.filter { letterGroup.contains($0.name) }
    }

    private let service: PotterServicing

    init(service: PotterServicing = PotterService()) {
        self.service = service
        super.init(pageSize: PotterCategory.characters.defaultPageSize) { page, size in
            try await service.fetchCharacters(page: page, pageSize: size, ascending: true)
        }
    }
}
