//
//  APIError.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decoding(Error)
    case transport(Error)
    case emptyData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "We were unable to build a valid request."
        case .invalidResponse:
            return "The museum responded with something unexpected. Please try again."
        case .decoding:
            return "We couldn't read the artworks from the response."
        case .transport:
            return "We couldn't reach the museum. Check your connection."
        case .emptyData:
            return "The museum did not send back any artworks."
        }
    }
}
