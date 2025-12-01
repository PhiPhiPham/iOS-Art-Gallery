import Foundation

enum PotterRecommendation: Hashable {
    case book(PotterBook)
    case movie(PotterMovie)
    case character(PotterCharacter)
    case potion(PotterPotion)
    case spell(PotterSpell)

    var id: String {
        switch self {
        case .book(let book): return book.id
        case .movie(let movie): return movie.id
        case .character(let character): return character.id
        case .potion(let potion): return potion.id
        case .spell(let spell): return spell.id
        }
    }

    var category: PotterCategory {
        switch self {
        case .book: return .books
        case .movie: return .movies
        case .character: return .characters
        case .potion: return .potions
        case .spell: return .spells
        }
    }

    var title: String {
        switch self {
        case .book(let book): return book.title
        case .movie(let movie): return movie.title
        case .character(let character): return character.name
        case .potion(let potion): return potion.name
        case .spell(let spell): return spell.name
        }
    }

    var subtitle: String {
        switch self {
        case .book(let book): return book.author ?? "Unknown author"
        case .movie(let movie): return movie.releaseDate ?? "Unknown release"
        case .character(let character): return character.primaryDescription.isEmpty ? "Character" : character.primaryDescription
        case .potion(let potion): return potion.effect ?? "Potion"
        case .spell(let spell): return spell.category ?? "Spell"
        }
    }

    var description: String {
        switch self {
        case .book(let book): return book.descriptionExcerpt
        case .movie(let movie): return movie.summary ?? "No synopsis available"
        case .character(let character):
            if let born = character.born {
                return "Born: \(born)"
            }
            return character.species ?? "Wizarding World"
        case .potion(let potion):
            return potion.characteristics ?? potion.effect ?? "A mysterious brew"
        case .spell(let spell):
            return spell.effect ?? "A magical incantation"
        }
    }

    var imageURL: URL? {
        switch self {
        case .book(let book): return book.coverURL
        case .movie(let movie): return movie.posterURL
        case .character(let character): return character.imageURL
        case .potion(let potion): return potion.imageURL
        case .spell(let spell): return spell.imageURL
        }
    }
}
