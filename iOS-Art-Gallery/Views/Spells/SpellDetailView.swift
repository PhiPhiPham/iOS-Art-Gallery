import SwiftUI

struct SpellDetailView: View {
    let spell: PotterSpell

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                heroSection
                infoSection
                if let effect = spell.effect {
                    detailCard(title: "Effect", value: effect)
                }
                if let creator = spell.creator, !creator.isEmpty {
                    detailCard(title: "Creator", value: creator)
                }
                if let wiki = spell.wikiURL {
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
        .navigationTitle(spell.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: spell.imageURL) { phase in
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
                            .frame(height: 220)
                        ProgressView()
                    }
                case .failure:
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .frame(height: 220)
                        .overlay {
                            Image(systemName: "wand.and.stars")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            if let incantation = spell.incantation {
                Label("Incantation: \(incantation)", systemImage: "quote.bubble")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            if let light = spell.light {
                Label("Light: \(light)", systemImage: "sparkles")
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
                KeyValueRow(key: "Category", value: spell.category)
                KeyValueRow(key: "Hand movement", value: spell.hand)
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
        SpellDetailView(spell: PreviewData.sampleSpell)
    }
}
