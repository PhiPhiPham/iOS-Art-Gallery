import SwiftUI

struct BookRowView: View {
    let book: PotterBook

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: book.coverURL) { phase in
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
                Text(book.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(book.author ?? "Unknown author")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(book.descriptionExcerpt)
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
                Image(systemName: "book")
                    .foregroundStyle(.secondary)
            }
    }
}

#Preview {
    BookRowView(book: PreviewData.sampleBook)
        .padding()
}
