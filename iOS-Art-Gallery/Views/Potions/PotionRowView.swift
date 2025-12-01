import SwiftUI

struct PotionRowView: View {
    let potion: PotterPotion

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: potion.imageURL) { phase in
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
                Text(potion.name)
                    .font(.headline)
                Text(potion.effect ?? "No description")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                if let difficulty = potion.difficulty {
                    Text("Difficulty: \(difficulty)")
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
                Image(systemName: "testtube.2")
                    .foregroundStyle(.secondary)
            }
    }
}

#Preview {
    PotionRowView(potion: PreviewData.samplePotion)
        .padding()
}
