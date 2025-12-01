import SwiftUI

struct CharacterRowView: View {
    let character: PotterCharacter

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: character.imageURL) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                case .empty:
                    placeholder
                case .failure:
                    placeholder
                @unknown default:
                    placeholder
                }
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                    .lineLimit(2)
                if !character.primaryDescription.isEmpty {
                    Text(character.primaryDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if let patronus = character.patronus, !patronus.isEmpty {
                    Text("Patronus: \(patronus)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 6)
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(.secondarySystemBackground))
            .frame(width: 60, height: 60)
            .overlay {
                Image(systemName: "person.crop.square")
                    .foregroundStyle(.secondary)
            }
    }
}

#Preview {
    CharacterRowView(character: PreviewData.sampleCharacter)
        .padding()
}
