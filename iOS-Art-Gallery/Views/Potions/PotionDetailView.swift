import SwiftUI

struct PotionDetailView: View {
    let potion: PotterPotion

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                heroSection
                infoSection
                if let ingredients = potion.ingredients, !ingredients.isEmpty {
                    detailCard(title: "Ingredients", value: ingredients)
                }
                if let sideEffects = potion.sideEffects, !sideEffects.isEmpty {
                    detailCard(title: "Side effects", value: sideEffects)
                }
                if let wiki = potion.wikiURL {
                    Link(destination: wiki) {
                        Label("Read more on the wiki", systemImage: "link")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(potion.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: potion.imageURL) { phase in
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
                            .frame(height: 200)
                        ProgressView()
                    }
                case .failure:
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .frame(height: 200)
                        .overlay {
                            Image(systemName: "testtube.2")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            if let effect = potion.effect {
                Text(effect)
                    .font(.headline)
            }
            if let characteristics = potion.characteristics {
                Text("Characteristics: \(characteristics)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Details")
                .font(.headline)
            VStack(spacing: 0) {
                KeyValueRow(key: "Difficulty", value: potion.difficulty)
                KeyValueRow(key: "Inventors", value: potion.inventors)
                KeyValueRow(key: "Manufacturers", value: potion.manufacturers)
                KeyValueRow(key: "Time", value: potion.time)
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
        PotionDetailView(potion: PreviewData.samplePotion)
    }
}
