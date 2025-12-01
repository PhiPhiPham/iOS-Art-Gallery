import Foundation

struct PotterBook: Identifiable, Decodable, Hashable {
    let id: String
    let slug: String?
    let title: String
    let author: String?
    let summary: String?
    let cover: String?
    let dedication: String?
    let pages: Int?
    let releaseDate: String?
    let wiki: String?

    var coverURL: URL? { cover.flatMap(URL.init(string:)) }
    var wikiURL: URL? { wiki.flatMap(URL.init(string:)) }

    var releaseDateText: String {
        guard let releaseDate, !releaseDate.isEmpty else { return "Unknown" }
        return releaseDate
    }

    var descriptionExcerpt: String {
        summary?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "No summary available"
    }

    init(
        id: String,
        slug: String? = nil,
        title: String,
        author: String? = nil,
        summary: String? = nil,
        cover: String? = nil,
        dedication: String? = nil,
        pages: Int? = nil,
        releaseDate: String? = nil,
        wiki: String? = nil
    ) {
        self.id = id
        self.slug = slug
        self.title = title
        self.author = author
        self.summary = summary
        self.cover = cover
        self.dedication = dedication
        self.pages = pages
        self.releaseDate = releaseDate
        self.wiki = wiki
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let attributes = try container.nestedContainer(keyedBy: AttributesCodingKeys.self, forKey: .attributes)
        slug = try attributes.decodeIfPresent(String.self, forKey: .slug)
        title = try attributes.decode(String.self, forKey: .title)
        author = try attributes.decodeIfPresent(String.self, forKey: .author)
        summary = try attributes.decodeIfPresent(String.self, forKey: .summary)
        cover = try attributes.decodeIfPresent(String.self, forKey: .cover)
        dedication = try attributes.decodeIfPresent(String.self, forKey: .dedication)
        pages = try attributes.decodeIfPresent(Int.self, forKey: .pages)
        releaseDate = try attributes.decodeIfPresent(String.self, forKey: .releaseDate)
        wiki = try attributes.decodeIfPresent(String.self, forKey: .wiki)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case attributes
    }

    private enum AttributesCodingKeys: String, CodingKey {
        case slug
        case title
        case author
        case summary
        case cover
        case dedication
        case pages
        case releaseDate = "release_date"
        case wiki
    }
}
