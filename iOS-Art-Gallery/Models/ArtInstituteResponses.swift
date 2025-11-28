//
//  ArtInstituteResponses.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import Foundation

struct ArtworksResponse: Decodable {
    let pagination: Pagination?
    let data: [Artwork]
    let config: ImageConfig?
}

struct ArtworkDetailResponse: Decodable {
    let data: Artwork
}

struct Pagination: Decodable {
    let total: Int?
    let limit: Int?
    let offset: Int?
    let totalPages: Int?
    let currentPage: Int?
    let nextURL: URL?

    enum CodingKeys: String, CodingKey {
        case total
        case limit
        case offset
        case totalPages = "total_pages"
        case currentPage = "current_page"
        case nextURL = "next_url"
    }
}

struct ImageConfig: Decodable {
    let iiifURL: URL?

    enum CodingKeys: String, CodingKey {
        case iiifURL = "iiif_url"
    }
}
