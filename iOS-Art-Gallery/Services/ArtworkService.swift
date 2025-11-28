//
//  ArtworkService.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import Foundation

protocol ArtworkServicing {
    func fetchArtworks(query: ArtworkQuery) async throws -> ArtworkPage
    func fetchArtwork(id: Int) async throws -> Artwork
    func fetchRelatedArtworks(for artist: String, excluding currentId: Int, limit: Int) async throws -> [Artwork]
}

struct ArtworkPage: Equatable {
    let artworks: [Artwork]
    let canLoadMore: Bool
}

final class ArtworkService: ArtworkServicing {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func fetchArtworks(query: ArtworkQuery) async throws -> ArtworkPage {
        let endpoint: ArtInstituteEndpoint
        if query.isSearchActive {
            endpoint = .search(
                page: query.page,
                limit: query.limit,
                query: query.trimmedSearch,
                fields: Artwork.requestFields,
                yearRange: query.yearRange
            )
        } else {
            endpoint = .artworks(
                page: query.page,
                limit: query.limit,
                fields: Artwork.requestFields,
                yearRange: query.yearRange
            )
        }

        let response: ArtworksResponse = try await data(for: endpoint)
        let currentPage = response.pagination?.currentPage ?? query.page
        let totalPages = response.pagination?.totalPages ?? currentPage
        let hasNextURL = response.pagination?.nextURL != nil
        let canLoadMore = currentPage < totalPages || hasNextURL
        return ArtworkPage(artworks: response.data, canLoadMore: canLoadMore)
    }

    func fetchArtwork(id: Int) async throws -> Artwork {
        let endpoint = ArtInstituteEndpoint.detail(id: id, fields: Artwork.requestFields)
        let response: ArtworkDetailResponse = try await data(for: endpoint)
        return response.data
    }

    func fetchRelatedArtworks(for artist: String, excluding currentId: Int, limit: Int) async throws -> [Artwork] {
        let endpoint = ArtInstituteEndpoint.related(artist: artist, limit: limit, fields: Artwork.requestFields)
        let response: ArtworksResponse = try await data(for: endpoint)
        return response.data.filter { $0.id != currentId }
    }

    private func data<T: Decodable>(for endpoint: ArtInstituteEndpoint) async throws -> T {
        do {
            let (data, response) = try await session.data(for: endpoint.makeRequest())
            guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
                throw APIError.invalidResponse
            }
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decoding(error)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.transport(error)
        }
    }
}
