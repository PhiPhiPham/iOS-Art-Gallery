//
//  ArtworkDetailView.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import SwiftUI

struct ArtworkDetailView: View {
    @StateObject private var viewModel: ArtworkDetailViewModel
    @State private var showFullscreen = false

    init(artwork: Artwork) {
        _viewModel = StateObject(wrappedValue: ArtworkDetailViewModel(artwork: artwork))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                heroImage
                infoSection
                if let artistStory = viewModel.artwork.artistDisplay, !artistStory.isEmpty {
                    detailCard(title: "About the artist", value: artistStory)
                }
                if let history = viewModel.artwork.publicationHistory, !history.isEmpty {
                    detailCard(title: "History", value: history)
                }
                relatedSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.artwork.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.downloadImage()
                } label: {
                    Label("Download", systemImage: "square.and.arrow.down")
                }
            }
        }
        .onAppear {
            viewModel.load()
        }
        .alert("Art Gallery", isPresented: $viewModel.isAlertVisible) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage ?? "")
        }
        .fullScreenCover(isPresented: $showFullscreen) {
            if let url = viewModel.artwork.heroImageURL {
                ArtworkFullscreenView(imageURL: url)
            }
        }
    }

    @ViewBuilder
    private var heroImage: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: viewModel.artwork.heroImageURL) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(18)
                        .overlay(alignment: .bottomTrailing) {
                            Button {
                                showFullscreen = true
                            } label: {
                                Label("View Fullscreen", systemImage: "arrow.up.left.and.arrow.down.right")
                                    .padding(8)
                                    .background(.regularMaterial, in: Capsule())
                            }
                            .padding()
                        }
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(.ultraThinMaterial)
                            .frame(height: 280)
                        ProgressView()
                    }
                case .failure:
                    imagePlaceholder
                @unknown default:
                    imagePlaceholder
                }
            }
            Text(viewModel.artwork.displayArtist)
                .font(.title3.bold())
            Text(viewModel.artwork.displayDate)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            infoRow(title: "Medium", value: viewModel.artwork.mediumDisplay)
            infoRow(title: "Dimensions", value: viewModel.artwork.dimensions)
            infoRow(title: "Origin", value: viewModel.artwork.placeOfOrigin)
            infoRow(title: "Department", value: viewModel.artwork.departmentTitle)
            infoRow(title: "Credit", value: viewModel.artwork.creditLine)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }

    private var relatedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("More from this artist")
                .font(.headline)
            switch viewModel.relatedState {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            case .empty(let message):
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            case .error(let message):
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            default:
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.relatedArtworks) { artwork in
                            NavigationLink(value: artwork) {
                                relatedCard(artwork)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }

    private func infoRow(title: String, value: String?) -> some View {
        HStack {
            Text(title)
                .font(.subheadline.bold())
            Spacer()
            Text(value ?? "Unknown")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }

    private func detailCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }

    private func relatedCard(_ artwork: Artwork) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: artwork.imageURL(width: 300)) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 200)
                        .clipped()
                        .cornerRadius(14)
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.ultraThinMaterial)
                            .frame(width: 160, height: 200)
                        ProgressView()
                    }
                case .failure:
                    relatedPlaceholder
                @unknown default:
                    relatedPlaceholder
                }
            }
            Text(artwork.title)
                .font(.subheadline.bold())
                .lineLimit(2)
            Text(artwork.displayDate)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(width: 160, alignment: .leading)
    }

    private var imagePlaceholder: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(.ultraThinMaterial)
            .frame(height: 280)
            .overlay {
                Image(systemName: "photo")
                    .font(.title)
                    .foregroundStyle(.secondary)
            }
    }

    private var relatedPlaceholder: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(.ultraThinMaterial)
            .frame(width: 160, height: 200)
            .overlay {
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            }
    }
}

#Preview {
    NavigationStack {
        ArtworkDetailView(artwork: PreviewData.sampleArtwork)
    }
}
