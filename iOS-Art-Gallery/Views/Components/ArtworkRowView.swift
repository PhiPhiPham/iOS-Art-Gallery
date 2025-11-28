//
//  ArtworkRowView.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import SwiftUI

struct ArtworkRowView: View {
    let artwork: Artwork

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: artwork.imageURL(width: 200)) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipped()
                        .cornerRadius(10)
                case .empty:
                    placeholder
                case .failure:
                    placeholder
                @unknown default:
                    placeholder
                }
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(artwork.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(artwork.displayArtist)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(artwork.displayDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }

    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
            Image(systemName: "photo")
                .foregroundStyle(.secondary)
        }
        .frame(width: 80, height: 80)
    }
}

#Preview {
    ArtworkRowView(artwork: PreviewData.sampleArtwork)
        .padding()
}
