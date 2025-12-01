import Foundation

struct PotterCharacter: Identifiable, Decodable, Hashable {
    let id: String
    let slug: String?
    let name: String
    let aliasNames: [String]
    let animagus: String?
    let bloodStatus: String?
    let boggart: String?
    let born: String?
    let died: String?
    let eyeColor: String?
    let familyMembers: [String]
    let gender: String?
    let hairColor: String?
    let height: String?
    let house: String?
    let image: String?
    let jobs: [String]
    let maritalStatus: String?
    let nationality: String?
    let patronus: String?
    let romances: [String]
    let skinColor: String?
    let species: String?
    let titles: [String]
    let wands: [String]
    let weight: String?
    let wiki: String?

    var imageURL: URL? { image.flatMap(URL.init(string:)) }
    var wikiURL: URL? { wiki.flatMap(URL.init(string:)) }

    var primaryDescription: String {
        [house, species].compactMap { $0 }.joined(separator: " • ")
    }

    init(
        id: String,
        slug: String? = nil,
        name: String,
        aliasNames: [String] = [],
        animagus: String? = nil,
        bloodStatus: String? = nil,
        boggart: String? = nil,
        born: String? = nil,
        died: String? = nil,
        eyeColor: String? = nil,
        familyMembers: [String] = [],
        gender: String? = nil,
        hairColor: String? = nil,
        height: String? = nil,
        house: String? = nil,
        image: String? = nil,
        jobs: [String] = [],
        maritalStatus: String? = nil,
        nationality: String? = nil,
        patronus: String? = nil,
        romances: [String] = [],
        skinColor: String? = nil,
        species: String? = nil,
        titles: [String] = [],
        wands: [String] = [],
        weight: String? = nil,
        wiki: String? = nil
    ) {
        self.id = id
        self.slug = slug
        self.name = name
        self.aliasNames = aliasNames
        self.animagus = animagus
        self.bloodStatus = bloodStatus
        self.boggart = boggart
        self.born = born
        self.died = died
        self.eyeColor = eyeColor
        self.familyMembers = familyMembers
        self.gender = gender
        self.hairColor = hairColor
        self.height = height
        self.house = house
        self.image = image
        self.jobs = jobs
        self.maritalStatus = maritalStatus
        self.nationality = nationality
        self.patronus = patronus
        self.romances = romances
        self.skinColor = skinColor
        self.species = species
        self.titles = titles
        self.wands = wands
        self.weight = weight
        self.wiki = wiki
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let attributes = try container.nestedContainer(keyedBy: AttributesCodingKeys.self, forKey: .attributes)
        slug = try attributes.decodeIfPresent(String.self, forKey: .slug)
        name = try attributes.decode(String.self, forKey: .name)
        aliasNames = try attributes.decodeIfPresent([String].self, forKey: .aliasNames) ?? []
        animagus = try attributes.decodeIfPresent(String.self, forKey: .animagus)
        bloodStatus = try attributes.decodeIfPresent(String.self, forKey: .bloodStatus)
        boggart = try attributes.decodeIfPresent(String.self, forKey: .boggart)
        born = try attributes.decodeIfPresent(String.self, forKey: .born)
        died = try attributes.decodeIfPresent(String.self, forKey: .died)
        eyeColor = try attributes.decodeIfPresent(String.self, forKey: .eyeColor)
        familyMembers = try attributes.decodeIfPresent([String].self, forKey: .familyMembers) ?? []
        gender = try attributes.decodeIfPresent(String.self, forKey: .gender)
        hairColor = try attributes.decodeIfPresent(String.self, forKey: .hairColor)
        height = try attributes.decodeIfPresent(String.self, forKey: .height)
        house = try attributes.decodeIfPresent(String.self, forKey: .house)
        image = try attributes.decodeIfPresent(String.self, forKey: .image)
        jobs = try attributes.decodeIfPresent([String].self, forKey: .jobs) ?? []
        maritalStatus = try attributes.decodeIfPresent(String.self, forKey: .maritalStatus)
        nationality = try attributes.decodeIfPresent(String.self, forKey: .nationality)
        patronus = try attributes.decodeIfPresent(String.self, forKey: .patronus)
        romances = try attributes.decodeIfPresent([String].self, forKey: .romances) ?? []
        skinColor = try attributes.decodeIfPresent(String.self, forKey: .skinColor)
        species = try attributes.decodeIfPresent(String.self, forKey: .species)
        titles = try attributes.decodeIfPresent([String].self, forKey: .titles) ?? []
        wands = try attributes.decodeIfPresent([String].self, forKey: .wands) ?? []
        weight = try attributes.decodeIfPresent(String.self, forKey: .weight)
        wiki = try attributes.decodeIfPresent(String.self, forKey: .wiki)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case attributes
    }

    private enum AttributesCodingKeys: String, CodingKey {
        case slug
        case name
        case aliasNames = "alias_names"
        case animagus
        case bloodStatus = "blood_status"
        case boggart
        case born
        case died
        case eyeColor = "eye_color"
        case familyMembers = "family_members"
        case gender
        case hairColor = "hair_color"
        case height
        case house
        case image
        case jobs
        case maritalStatus = "marital_status"
        case nationality
        case patronus
        case romances
        case skinColor = "skin_color"
        case species
        case titles
        case wands
        case weight
        case wiki
    }
}
