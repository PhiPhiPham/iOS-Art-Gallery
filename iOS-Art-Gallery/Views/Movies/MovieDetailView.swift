import SwiftUI

struct MovieDetailView: View {
    let movie: PotterMovie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                heroSection
                if let summary = movie.summary {
                    detailCard(title: "Synopsis", value: summary)
                }
                infoSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 10)
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .frame(height: 260)
                        ProgressView()
                    }
                case .failure:
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .frame(height: 260)
                        .overlay {
                            Image(systemName: "film")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            HStack(spacing: 12) {
                Label(movie.releaseDate ?? "Unknown", systemImage: "calendar")
                Label(movie.rating ?? "Unrated", systemImage: "star")
                Label(movie.runningTime ?? "?", systemImage: "clock")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Crew")
                .font(.headline)
            VStack(spacing: 0) {
                KeyValueRow(key: "Directors", value: movie.directors.joined(separator: ", "))
                KeyValueRow(key: "Producers", value: movie.producers.joined(separator: ", "))
                KeyValueRow(key: "Writers", value: movie.writers.joined(separator: ", "))
                KeyValueRow(key: "Music", value: movie.musicComposers.joined(separator: ", "))
                KeyValueRow(key: "Cinematography", value: movie.cinematographers.joined(separator: ", "))
                KeyValueRow(key: "Distributors", value: movie.distributors.joined(separator: ", "))
                KeyValueRow(key: "Box Office", value: movie.boxOffice)
                KeyValueRow(key: "Budget", value: movie.budget)
                if let trailer = movie.trailerURL {
                    Divider()
                    Link(destination: trailer) {
                        Label("Watch trailer", systemImage: "play.circle")
                            .font(.subheadline.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                if let wiki = movie.wikiURL {
                    Divider()
                    Link(destination: wiki) {
                        Label("Read on the wiki", systemImage: "link")
                            .font(.subheadline.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(.background))
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        }
    }

    private func detailCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16).fill(.background))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(movie: PreviewData.sampleMovie)
    }
}
