import Foundation

struct PotterChapter: Identifiable, Decodable, Hashable {
    let id: String
    let slug: String?
    let title: String
    let summary: String?
    let order: Int?

    init(id: String, slug: String? = nil, title: String, summary: String? = nil, order: Int? = nil) {
        self.id = id
        self.slug = slug
        self.title = title
        self.summary = summary
        self.order = order
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let attributes = try container.nestedContainer(keyedBy: AttributesCodingKeys.self, forKey: .attributes)
        slug = try attributes.decodeIfPresent(String.self, forKey: .slug)
        title = try attributes.decode(String.self, forKey: .title)
        summary = try attributes.decodeIfPresent(String.self, forKey: .summary)
        order = try attributes.decodeIfPresent(Int.self, forKey: .order)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case attributes
    }

    private enum AttributesCodingKeys: String, CodingKey {
        case slug
        case title
        case summary
        case order
    }
}
