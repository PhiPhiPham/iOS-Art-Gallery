import Foundation

struct PotterPotion: Identifiable, Decodable, Hashable {
    let id: String
    let slug: String?
    let name: String
    let characteristics: String?
    let difficulty: String?
    let effect: String?
    let image: String?
    let inventors: String?
    let ingredients: String?
    let manufacturers: String?
    let sideEffects: String?
    let time: String?
    let wiki: String?

    var imageURL: URL? { image.flatMap(URL.init(string:)) }
    var wikiURL: URL? { wiki.flatMap(URL.init(string:)) }

    init(
        id: String,
        slug: String? = nil,
        name: String,
        characteristics: String? = nil,
        difficulty: String? = nil,
        effect: String? = nil,
        image: String? = nil,
        inventors: String? = nil,
        ingredients: String? = nil,
        manufacturers: String? = nil,
        sideEffects: String? = nil,
        time: String? = nil,
        wiki: String? = nil
    ) {
        self.id = id
        self.slug = slug
        self.name = name
        self.characteristics = characteristics
        self.difficulty = difficulty
        self.effect = effect
        self.image = image
        self.inventors = inventors
        self.ingredients = ingredients
        self.manufacturers = manufacturers
        self.sideEffects = sideEffects
        self.time = time
        self.wiki = wiki
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let attributes = try container.nestedContainer(keyedBy: AttributesCodingKeys.self, forKey: .attributes)
        slug = try attributes.decodeIfPresent(String.self, forKey: .slug)
        name = try attributes.decode(String.self, forKey: .name)
        characteristics = try attributes.decodeIfPresent(String.self, forKey: .characteristics)
        difficulty = try attributes.decodeIfPresent(String.self, forKey: .difficulty)
        effect = try attributes.decodeIfPresent(String.self, forKey: .effect)
        image = try attributes.decodeIfPresent(String.self, forKey: .image)
        inventors = try attributes.decodeIfPresent(String.self, forKey: .inventors)
        ingredients = try attributes.decodeIfPresent(String.self, forKey: .ingredients)
        manufacturers = try attributes.decodeIfPresent(String.self, forKey: .manufacturers)
        sideEffects = try attributes.decodeIfPresent(String.self, forKey: .sideEffects)
        time = try attributes.decodeIfPresent(String.self, forKey: .time)
        wiki = try attributes.decodeIfPresent(String.self, forKey: .wiki)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case attributes
    }

    private enum AttributesCodingKeys: String, CodingKey {
        case slug
        case name
        case characteristics
        case difficulty
        case effect
        case image
        case inventors
        case ingredients
        case manufacturers
        case sideEffects = "side_effects"
        case time
        case wiki
    }
}
