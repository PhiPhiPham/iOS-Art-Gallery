//
//  YearRange.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import Foundation

struct YearRange: Equatable {
    var startYear: Int?
    var endYear: Int?

    var isEmpty: Bool {
        startYear == nil && endYear == nil
    }

    func contains(year: Int?) -> Bool {
        guard let year else { return isEmpty }
        if let startYear, year < startYear { return false }
        if let endYear, year > endYear { return false }
        return true
    }

    var description: String {
        switch (startYear, endYear) {
        case (nil, nil):
            return "All years"
        case (let start?, let end?):
            return "\(start) – \(end)"
        case (let start?, nil):
            return "\(start)+"
        case (nil, let end?):
            return "≤ \(end)"
        }
    }

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        if let startYear {
            items.append(URLQueryItem(name: "query[range][date_start][gte]", value: "\(startYear)"))
        }
        if let endYear {
            items.append(URLQueryItem(name: "query[range][date_start][lte]", value: "\(endYear)"))
        }
        return items
    }
}
