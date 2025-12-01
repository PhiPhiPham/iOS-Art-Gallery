import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView(viewModel: HomeViewModel())
                .navigationDestination(for: PotterCategory.self) { category in
                    switch category {
                    case .books:
                        BookListView()
                    case .characters:
                        CharacterListView()
                    case .movies:
                        MovieListView()
                    case .potions:
                        PotionListView()
                    case .spells:
                        SpellListView()
                    }
                }
                .navigationDestination(for: PotterBook.self) { book in
                    BookDetailView(book: book)
                }
                .navigationDestination(for: PotterMovie.self) { movie in
                    MovieDetailView(movie: movie)
                }
                .navigationDestination(for: PotterCharacter.self) { character in
                    CharacterDetailView(character: character)
                }
                .navigationDestination(for: PotterPotion.self) { potion in
                    PotionDetailView(potion: potion)
                }
                .navigationDestination(for: PotterSpell.self) { spell in
                    SpellDetailView(spell: spell)
                }
        }
    }
}

#Preview {
    ContentView()
}
