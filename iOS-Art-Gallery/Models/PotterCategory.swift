import Foundation

enum PotterCategory: String, CaseIterable, Identifiable {
    case books
    case characters
    case movies
    case potions
    case spells

    var id: String { rawValue }

    var title: String {
        switch self {
        case .books: return "Books"
        case .characters: return "Characters"
        case .movies: return "Movies"
        case .potions: return "Potions"
        case .spells: return "Spells"
        }
    }

    var systemIconName: String {
        switch self {
        case .books: return "book"
        case .characters: return "person.2"
        case .movies: return "film"
        case .potions: return "testtube.2"
        case .spells: return "wand.and.stars"
        }
    }

    var path: String {
        switch self {
        case .books: return "/books"
        case .characters: return "/characters"
        case .movies: return "/movies"
        case .potions: return "/potions"
        case .spells: return "/spells"
        }
    }

    var defaultPageSize: Int {
        switch self {
        case .books: return 10
        case .characters: return 20
        case .movies: return 5
        case .potions: return 20
        case .spells: return 20
        }
    }

    var tagline: String {
        switch self {
        case .books: return "All seven novels and more"
        case .characters: return "Every witch and wizard"
        case .movies: return "Films, trailers, and facts"
        case .potions: return "Ingredients, effects, and lore"
        case .spells: return "Incantations and usage"
        }
    }
}
