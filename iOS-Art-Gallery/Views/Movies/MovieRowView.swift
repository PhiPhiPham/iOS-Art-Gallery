import SwiftUI

struct MovieRowView: View {
    let movie: PotterMovie

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                case .empty:
                    placeholder
                case .failure:
                    placeholder
                @unknown default:
                    placeholder
                }
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(movie.releaseDate ?? "Unknown release")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(movie.summary ?? "No summary available")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
        }
        .padding(.vertical, 8)
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.secondarySystemBackground))
            .frame(width: 70, height: 100)
            .overlay {
                Image(systemName: "film")
                    .foregroundStyle(.secondary)
            }
    }
}

#Preview {
    MovieRowView(movie: PreviewData.sampleMovie)
        .padding()
}
