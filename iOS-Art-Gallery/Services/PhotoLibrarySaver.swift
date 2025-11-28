//
//  PhotoLibrarySaver.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import Photos
import UIKit

protocol PhotoLibrarySaving {
    func saveImage(from url: URL) async throws
}

enum PhotoSaveError: LocalizedError {
    case denied
    case invalidImage

    var errorDescription: String? {
        switch self {
        case .denied:
            return "Please allow access to your Photo Library to save artworks."
        case .invalidImage:
            return "We couldn't create an image file from the selected artwork."
        }
    }
}

final class PhotoLibrarySaver: PhotoLibrarySaving {
    func saveImage(from url: URL) async throws {
        try await requestAccessIfNeeded()
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
            throw APIError.invalidResponse
        }
        guard let image = UIImage(data: data) else {
            throw PhotoSaveError.invalidImage
        }

        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }
    }

    private func requestAccessIfNeeded() async throws {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        switch status {
        case .notDetermined:
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
            guard newStatus == .authorized || newStatus == .limited else {
                throw PhotoSaveError.denied
            }
        case .restricted, .denied:
            throw PhotoSaveError.denied
        default:
            break
        }
    }
}

private extension PHPhotoLibrary {
    func performChanges(_ changes: @escaping () -> Void) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            performChanges(changes) { success, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: PhotoSaveError.invalidImage)
                }
            }
        }
    }
}
