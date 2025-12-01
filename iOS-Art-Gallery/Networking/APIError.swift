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
            return "The wizarding archive responded with something unexpected. Please try again."
        case .decoding:
            return "We couldn't read the data from the response."
        case .transport:
            return "We couldn't reach the wizarding archive. Check your connection."
        case .emptyData:
            return "No entries were returned from the archive."
        }
    }
}
