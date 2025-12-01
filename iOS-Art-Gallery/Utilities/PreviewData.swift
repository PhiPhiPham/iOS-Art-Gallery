import SwiftUI

enum PreviewData {
    static let sampleBook = PotterBook(
        id: "book-1",
        slug: "harry-potter-and-the-philosophers-stone",
        title: "Harry Potter and the Philosopher's Stone",
        author: "J. K. Rowling",
        summary: "Harry discovers he is a wizard and heads to Hogwarts where a mystery about the Philosopher's Stone awaits.",
        cover: "https://www.wizardingworld.com/images/products/books/UK/rectangle-1.jpg",
        dedication: "For Jessica, who loves stories...",
        pages: 223,
        releaseDate: "1997-06-26",
        wiki: "https://harrypotter.fandom.com/wiki/Harry_Potter_and_the_Philosopher's_Stone"
    )

    static let sampleMovie = PotterMovie(
        id: "movie-1",
        slug: "harry-potter-and-the-philosophers-stone",
        title: "Harry Potter and the Philosopher's Stone",
        summary: "Harry begins his first year at Hogwarts School of Witchcraft and Wizardry.",
        poster: "https://www.wizardingworld.com/images/products/films/rectangle-1.png",
        releaseDate: "2001-11-04",
        rating: "PG",
        runningTime: "152 minutes",
        directors: ["Chris Columbus"],
        producers: ["David Heyman"],
        writers: ["Steve Kloves"],
        musicComposers: ["John Williams"],
        cinematographers: ["John Seale"],
        distributors: ["Warner Bros. Pictures"],
        boxOffice: "$1.018 billion",
        budget: "$125 million",
        trailer: "https://www.youtube.com/watch?v=PbdM1db3JbY",
        wiki: "https://harrypotter.fandom.com/wiki/Harry_Potter_and_the_Philosopher's_Stone_(film)"
    )

    static let sampleCharacter = PotterCharacter(
        id: "character-1",
        slug: "harry-potter",
        name: "Harry Potter",
        aliasNames: ["The Boy Who Lived", "The Chosen One"],
        animagus: nil,
        bloodStatus: "Half-blood",
        boggart: "Dementor",
        born: "31 July 1980",
        died: nil,
        eyeColor: "Green",
        familyMembers: ["James Potter", "Lily Potter", "Ginny Potter"],
        gender: "Male",
        hairColor: "Black",
        height: "5'11\"",
        house: "Gryffindor",
        image: "https://static.wikia.nocookie.net/harrypotter/images/0/0d/Harry_Potter.jpg",
        jobs: ["Auror", "Hogwarts Defense Against the Dark Arts professor"],
        maritalStatus: "Married",
        nationality: "British",
        patronus: "Stag",
        romances: ["Cho Chang", "Ginny Weasley"],
        skinColor: "Fair",
        species: "Human",
        titles: ["Seeker", "Head of the Auror Office"],
        wands: ["11\" Holly, Phoenix Feather"],
        weight: nil,
        wiki: "https://harrypotter.fandom.com/wiki/Harry_Potter"
    )

    static let samplePotion = PotterPotion(
        id: "potion-1",
        slug: "polyjuice-potion",
        name: "Polyjuice Potion",
        characteristics: "Thick, mud-like", difficulty: "Advanced",
        effect: "Temporarily transforms the drinker into someone else",
        image: "https://static.wikia.nocookie.net/harrypotter/images/1/1d/Polyjuice_Potion_PM.png",
        inventors: "Severus Snape",
        ingredients: "Lacewing flies, Leeches, Fluxweed, Knotgrass, Boomslang skin, Bicorn horn, Powdered human form",
        manufacturers: nil,
        sideEffects: "Incomplete transformations if brewed incorrectly",
        time: "One month",
        wiki: "https://harrypotter.fandom.com/wiki/Polyjuice_Potion"
    )

    static let sampleSpell = PotterSpell(
        id: "spell-1",
        slug: "expelliarmus",
        name: "Expelliarmus",
        category: "Charm",
        creator: "Illegitimate",
        effect: "Disarms an opponent",
        hand: "Swipe",
        image: "https://static.wikia.nocookie.net/harrypotter/images/d/d3/Expelliarmus_PM.png",
        incantation: "Expelliarmus",
        light: "Red",
        wiki: "https://harrypotter.fandom.com/wiki/Expelliarmus"
    )

    static var homeViewModel: HomeViewModel {
        HomeViewModel.preview(recommendation: .book(sampleBook))
    }
}

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(_ initialValue: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
