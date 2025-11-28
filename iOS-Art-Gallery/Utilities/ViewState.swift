//
//  ViewState.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import Foundation

enum ViewState: Equatable {
    case idle
    case loading
    case loaded
    case empty(message: String)
    case error(message: String)
}
