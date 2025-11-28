//
//  ArtworkFullscreenView.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import SwiftUI

struct ArtworkFullscreenView: View {
    @Environment(\.dismiss) private var dismiss
    let imageURL: URL

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFit()
                            .padding()
                    case .failure:
                        VStack(spacing: 12) {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                            Text("Unable to load image")
                                .foregroundStyle(.white)
                        }
                    case .empty:
                        ProgressView()
                            .tint(.white)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .tint(.white)
                }
            }
        }
    }
}

#Preview {
    ArtworkFullscreenView(imageURL: URL(string: "https://www.artic.edu/iiif/2/123/full/843,/0/default.jpg")!)
}
