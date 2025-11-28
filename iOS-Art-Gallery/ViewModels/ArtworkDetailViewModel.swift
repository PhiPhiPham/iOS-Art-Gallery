//
//  ArtworkDetailViewModel.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import Combine
import Foundation

enum DownloadState: Equatable {
    case idle
    case saving
    case success(message: String)
    case failure(message: String)
}

@MainActor
final class ArtworkDetailViewModel: ObservableObject {
    @Published private(set) var artwork: Artwork
    @Published private(set) var detailState: ViewState = .idle
    @Published private(set) var relatedState: ViewState = .idle
    @Published private(set) var relatedArtworks: [Artwork] = []
    @Published private(set) var downloadState: DownloadState = .idle
    @Published var alertMessage: String?
    @Published var isAlertVisible = false

    private let service: ArtworkServicing
    private let photoSaver: PhotoLibrarySaving
    private var detailTask: Task<Void, Never>?
    private var relatedTask: Task<Void, Never>?
    private var downloadTask: Task<Void, Never>?

    init(artwork: Artwork, service: ArtworkServicing = ArtworkService(), photoSaver: PhotoLibrarySaving = PhotoLibrarySaver()) {
        self.artwork = artwork
        self.service = service
        self.photoSaver = photoSaver
    }

    func load() {
        fetchDetail()
        fetchRelated()
    }

    func fetchDetail() {
        detailTask?.cancel()
        detailState = .loading
        let artworkID = artwork.id
        detailTask = Task { [weak self] in
            guard let self else { return }
            do {
                let detail = try await service.fetchArtwork(id: artworkID)
                await MainActor.run {
                    self.artwork = detail
                    self.detailState = .loaded
                }
            } catch {
                await MainActor.run {
                    let message = self.trim(error)
                    self.detailState = .error(message: message)
                    self.alert(message: message)
                }
            }
        }
    }

    func fetchRelated() {
        guard let artist = artwork.artistTitle, !artist.isEmpty else {
            relatedState = .empty(message: "No artist listed for this artwork.")
            return
        }

        relatedTask?.cancel()
        relatedState = .loading
        let artworkID = artwork.id
        relatedTask = Task { [weak self] in
            guard let self else { return }
            do {
                let artworks = try await service.fetchRelatedArtworks(for: artist, excluding: artworkID, limit: 10)
                await MainActor.run {
                    self.relatedArtworks = artworks
                    self.relatedState = artworks.isEmpty ? .empty(message: "No other artworks from this artist were found.") : .loaded
                }
            } catch {
                await MainActor.run {
                    self.relatedState = .error(message: self.trim(error))
                }
            }
        }
    }

    func downloadImage() {
        guard let url = artwork.heroImageURL else {
            alert(message: "No high-resolution image available.")
            downloadState = .failure(message: "No image to download.")
            return
        }

        downloadTask?.cancel()
        downloadState = .saving
        downloadTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await photoSaver.saveImage(from: url)
                await MainActor.run {
                    self.downloadState = .success(message: "Saved to your Photos library!")
                    self.alert(message: "Artwork saved to your library.")
                }
            } catch {
                await MainActor.run {
                    self.downloadState = .failure(message: error.localizedDescription)
                    self.alert(message: self.trim(error))
                }
            }
        }
    }

    private func alert(message: String) {
        alertMessage = message
        isAlertVisible = true
    }

    private func trim(_ error: Error) -> String {
        if let localized = error as? LocalizedError, let description = localized.errorDescription {
            return description
        }
        return "Something went wrong. Please try again."
    }
}
