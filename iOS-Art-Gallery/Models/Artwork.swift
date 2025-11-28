//
//  Artwork.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import Foundation

struct Artwork: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let artistTitle: String?
    let artistDisplay: String?
    let artistDisplayBio: String?
    let dateDisplay: String?
    let dateStart: Int?
    let dateEnd: Int?
    let placeOfOrigin: String?
    let mediumDisplay: String?
    let dimensions: String?
    let creditLine: String?
    let artworkTypeTitle: String?
    let departmentTitle: String?
    let publicationHistory: String?
    let imageId: String?
    let thumbnail: Thumbnail?
    let apiModel: String?
    let artworkTypeId: Int?
    let artistIds: [Int]?
    let termTitles: [String]?
    let styleTitles: [String]?
    let subjectTitles: [String]?
    let materialTitles: [String]?
    let dateUpdated: Date?
    let isPublicDomain: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case artistTitle = "artist_title"
        case artistDisplay = "artist_display"
        case artistDisplayBio = "artist_display_bio"
        case dateDisplay = "date_display"
        case dateStart = "date_start"
        case dateEnd = "date_end"
        case placeOfOrigin = "place_of_origin"
        case mediumDisplay = "medium_display"
        case dimensions
        case creditLine = "credit_line"
        case artworkTypeTitle = "artwork_type_title"
        case departmentTitle = "department_title"
        case publicationHistory = "publication_history"
        case imageId = "image_id"
        case thumbnail
        case apiModel = "api_model"
        case artworkTypeId = "artwork_type_id"
        case artistIds = "artist_ids"
        case termTitles = "term_titles"
        case styleTitles = "style_titles"
        case subjectTitles = "subject_titles"
        case materialTitles = "material_titles"
        case dateUpdated = "date_updated"
        case isPublicDomain = "is_public_domain"
    }
}

extension Artwork {
    static var requestFields: String {
        [
            "id", "title", "artist_title", "artist_display", "artist_display_bio",
            "date_display", "date_start", "date_end", "place_of_origin", "medium_display",
            "dimensions", "credit_line", "artwork_type_title", "department_title",
            "publication_history", "image_id", "thumbnail", "term_titles", "style_titles",
            "subject_titles", "material_titles", "is_public_domain"
        ].joined(separator: ",")
    }

    var displayArtist: String {
        artistTitle ?? "Unknown Artist"
    }

    var displayDate: String {
        if let dateDisplay {
            return dateDisplay
        }
        switch (dateStart, dateEnd) {
        case let (start?, end?):
            return start == end ? "\(start)" : "\(start) – \(end)"
        case let (start?, nil):
            return "From \(start)"
        case let (nil, end?):
            return "Until \(end)"
        default:
            return "Date unknown"
        }
    }

    func imageURL(width: Int = 500) -> URL? {
        guard let imageId else { return nil }
        return URL(string: "https://www.artic.edu/iiif/2/\(imageId)/full/\(width),/0/default.jpg")
    }

    var heroImageURL: URL? {
        imageURL(width: 800)
    }
}

struct Thumbnail: Codable, Hashable {
    let lqip: String?
    let width: Int?
    let height: Int?
    let altText: String?

    enum CodingKeys: String, CodingKey {
        case lqip
        case width
        case height
        case altText = "alt_text"
    }
}
