//
//  ArtInstituteEndpoint.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import Foundation

enum ArtInstituteEndpoint {
    case artworks(page: Int, limit: Int, fields: String, yearRange: YearRange)
    case search(page: Int, limit: Int, query: String, fields: String, yearRange: YearRange)
    case detail(id: Int, fields: String)
    case related(artist: String, limit: Int, fields: String)

    func makeRequest() throws -> URLRequest {
        let baseURL = URL(string: "https://api.artic.edu/api/v1")!
        let url = baseURL.appending(path: path)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }

        components.queryItems = queryItems

        guard let finalURL = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: finalURL)
        request.timeoutInterval = 20
        return request
    }

    private var path: String {
        switch self {
        case .artworks:
            return "/artworks"
        case .search:
            return "/artworks/search"
        case let .detail(id, _):
            return "/artworks/\(id)"
        case .related:
            return "/artworks/search"
        }
    }

    private var queryItems: [URLQueryItem] {
        switch self {
        case let .artworks(page, limit, fields, yearRange):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "fields", value: fields),
                URLQueryItem(name: "sort", value: "popular"),
                URLQueryItem(name: "query[term][is_public_domain]", value: "true"),
            ] + yearRange.queryItems
        case let .search(page, limit, query, fields, yearRange):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "fields", value: fields),
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "query[term][is_public_domain]", value: "true")
            ] + yearRange.queryItems
        case let .detail(_, fields):
            return [
                URLQueryItem(name: "fields", value: fields)
            ]
        case let .related(artist, limit, fields):
            return [
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "fields", value: fields),
                URLQueryItem(name: "q", value: artist),
                URLQueryItem(name: "query[term][artist_title]", value: artist),
                URLQueryItem(name: "query[term][is_public_domain]", value: "true")
            ]
        }
    }
}
