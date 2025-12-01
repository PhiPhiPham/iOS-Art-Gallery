import Foundation

struct PotterSpell: Identifiable, Decodable, Hashable {
    let id: String
    let slug: String?
    let name: String
    let category: String?
    let creator: String?
    let effect: String?
    let hand: String?
    let image: String?
    let incantation: String?
    let light: String?
    let wiki: String?

    var imageURL: URL? { image.flatMap(URL.init(string:)) }
    var wikiURL: URL? { wiki.flatMap(URL.init(string:)) }

    init(
        id: String,
        slug: String? = nil,
        name: String,
        category: String? = nil,
        creator: String? = nil,
        effect: String? = nil,
        hand: String? = nil,
        image: String? = nil,
        incantation: String? = nil,
        light: String? = nil,
        wiki: String? = nil
    ) {
        self.id = id
        self.slug = slug
        self.name = name
        self.category = category
        self.creator = creator
        self.effect = effect
        self.hand = hand
        self.image = image
        self.incantation = incantation
        self.light = light
        self.wiki = wiki
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let attributes = try container.nestedContainer(keyedBy: AttributesCodingKeys.self, forKey: .attributes)
        slug = try attributes.decodeIfPresent(String.self, forKey: .slug)
        name = try attributes.decode(String.self, forKey: .name)
        category = try attributes.decodeIfPresent(String.self, forKey: .category)
        creator = try attributes.decodeIfPresent(String.self, forKey: .creator)
        effect = try attributes.decodeIfPresent(String.self, forKey: .effect)
        hand = try attributes.decodeIfPresent(String.self, forKey: .hand)
        image = try attributes.decodeIfPresent(String.self, forKey: .image)
        incantation = try attributes.decodeIfPresent(String.self, forKey: .incantation)
        light = try attributes.decodeIfPresent(String.self, forKey: .light)
        wiki = try attributes.decodeIfPresent(String.self, forKey: .wiki)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case attributes
    }

    private enum AttributesCodingKeys: String, CodingKey {
        case slug
        case name
        case category
        case creator
        case effect
        case hand
        case image
        case incantation
        case light
        case wiki
    }
}
