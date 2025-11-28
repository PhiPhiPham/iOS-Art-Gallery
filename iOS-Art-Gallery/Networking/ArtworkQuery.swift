//
//  ArtworkQuery.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import Foundation

struct ArtworkQuery: Equatable {
    var page: Int = 1
    var limit: Int = 20
    var searchTerm: String = ""
    var yearRange: YearRange = .init()

    var trimmedSearch: String {
        searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isSearchActive: Bool {
        !trimmedSearch.isEmpty
    }

    mutating func resetPagination() {
        page = 1
    }
}
