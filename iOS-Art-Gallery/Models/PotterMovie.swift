import Foundation

struct PotterMovie: Identifiable, Decodable, Hashable {
    let id: String
    let slug: String?
    let title: String
    let summary: String?
    let poster: String?
    let releaseDate: String?
    let rating: String?
    let runningTime: String?
    let directors: [String]
    let producers: [String]
    let writers: [String]
    let musicComposers: [String]
    let cinematographers: [String]
    let distributors: [String]
    let boxOffice: String?
    let budget: String?
    let trailer: String?
    let wiki: String?

    var posterURL: URL? { poster.flatMap(URL.init(string:)) }
    var trailerURL: URL? { trailer.flatMap(URL.init(string:)) }
    var wikiURL: URL? { wiki.flatMap(URL.init(string:)) }

    init(
        id: String,
        slug: String? = nil,
        title: String,
        summary: String? = nil,
        poster: String? = nil,
        releaseDate: String? = nil,
        rating: String? = nil,
        runningTime: String? = nil,
        directors: [String] = [],
        producers: [String] = [],
        writers: [String] = [],
        musicComposers: [String] = [],
        cinematographers: [String] = [],
        distributors: [String] = [],
        boxOffice: String? = nil,
        budget: String? = nil,
        trailer: String? = nil,
        wiki: String? = nil
    ) {
        self.id = id
        self.slug = slug
        self.title = title
        self.summary = summary
        self.poster = poster
        self.releaseDate = releaseDate
        self.rating = rating
        self.runningTime = runningTime
        self.directors = directors
        self.producers = producers
        self.writers = writers
        self.musicComposers = musicComposers
        self.cinematographers = cinematographers
        self.distributors = distributors
        self.boxOffice = boxOffice
        self.budget = budget
        self.trailer = trailer
        self.wiki = wiki
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let attributes = try container.nestedContainer(keyedBy: AttributesCodingKeys.self, forKey: .attributes)
        slug = try attributes.decodeIfPresent(String.self, forKey: .slug)
        title = try attributes.decode(String.self, forKey: .title)
        summary = try attributes.decodeIfPresent(String.self, forKey: .summary)
        poster = try attributes.decodeIfPresent(String.self, forKey: .poster)
        releaseDate = try attributes.decodeIfPresent(String.self, forKey: .releaseDate)
        rating = try attributes.decodeIfPresent(String.self, forKey: .rating)
        runningTime = try attributes.decodeIfPresent(String.self, forKey: .runningTime)
        directors = try attributes.decodeIfPresent([String].self, forKey: .directors) ?? []
        producers = try attributes.decodeIfPresent([String].self, forKey: .producers) ?? []
        writers = try attributes.decodeIfPresent([String].self, forKey: .screenwriters) ?? []
        musicComposers = try attributes.decodeIfPresent([String].self, forKey: .musicComposers) ?? []
        cinematographers = try attributes.decodeIfPresent([String].self, forKey: .cinematographers) ?? []
        distributors = try attributes.decodeIfPresent([String].self, forKey: .distributors) ?? []
        boxOffice = try attributes.decodeIfPresent(String.self, forKey: .boxOffice)
        budget = try attributes.decodeIfPresent(String.self, forKey: .budget)
        trailer = try attributes.decodeIfPresent(String.self, forKey: .trailer)
        wiki = try attributes.decodeIfPresent(String.self, forKey: .wiki)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case attributes
    }

    private enum AttributesCodingKeys: String, CodingKey {
        case slug
        case title
        case summary
        case poster
        case releaseDate = "release_date"
        case rating
        case runningTime = "running_time"
        case directors
        case producers
        case screenwriters
        case musicComposers = "music_composers"
        case cinematographers
        case distributors
        case boxOffice = "box_office"
        case budget
        case trailer
        case wiki
    }
}
