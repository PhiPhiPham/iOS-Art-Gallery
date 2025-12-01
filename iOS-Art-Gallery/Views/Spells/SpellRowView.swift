import SwiftUI

struct SpellRowView: View {
    let spell: PotterSpell

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: spell.imageURL) { phase in
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
                Text(spell.name)
                    .font(.headline)
                Text(spell.category ?? "Spell")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(spell.effect ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 6)
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(.secondarySystemBackground))
            .frame(width: 60, height: 60)
            .overlay {
                Image(systemName: "wand.and.stars")
                    .foregroundStyle(.secondary)
            }
    }
}

#Preview {
    SpellRowView(spell: PreviewData.sampleSpell)
        .padding()
}
