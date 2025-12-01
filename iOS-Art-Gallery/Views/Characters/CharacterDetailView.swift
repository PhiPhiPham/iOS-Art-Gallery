import SwiftUI

struct CharacterDetailView: View {
    let character: PotterCharacter

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                heroSection
                infoSection
                if !character.aliasNames.isEmpty {
                    detailCard(title: "Also known as", value: character.aliasNames.joined(separator: ", "))
                }
                if !character.familyMembers.isEmpty {
                    detailCard(title: "Family", value: character.familyMembers.joined(separator: ", "))
                }
                if !character.romances.isEmpty {
                    detailCard(title: "Romances", value: character.romances.joined(separator: ", "))
                }
                if !character.titles.isEmpty {
                    detailCard(title: "Titles", value: character.titles.joined(separator: ", "))
                }
                if !character.wands.isEmpty {
                    detailCard(title: "Wands", value: character.wands.joined(separator: ", "))
                }
                if let wiki = character.wikiURL {
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
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: character.imageURL) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 10)
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .frame(height: 240)
                        ProgressView()
                    }
                case .failure:
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .frame(height: 240)
                        .overlay {
                            Image(systemName: "person.crop.square")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            if let house = character.house {
                Label(house, systemImage: "shield.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            if let species = character.species {
                Label(species, systemImage: "wand.and.stars")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Profile")
                .font(.headline)
            VStack(spacing: 0) {
                KeyValueRow(key: "Born", value: character.born)
                KeyValueRow(key: "Died", value: character.died)
                KeyValueRow(key: "Gender", value: character.gender)
                KeyValueRow(key: "Blood status", value: character.bloodStatus)
                KeyValueRow(key: "Height", value: character.height)
                KeyValueRow(key: "Weight", value: character.weight)
                KeyValueRow(key: "Eye color", value: character.eyeColor)
                KeyValueRow(key: "Hair color", value: character.hairColor)
                KeyValueRow(key: "Skin color", value: character.skinColor)
                KeyValueRow(key: "Patronus", value: character.patronus)
                KeyValueRow(key: "Animagus", value: character.animagus)
                KeyValueRow(key: "Boggart", value: character.boggart)
                KeyValueRow(key: "Nationality", value: character.nationality)
                if !character.jobs.isEmpty {
                    KeyValueRow(key: "Jobs", value: character.jobs.joined(separator: ", "))
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
        CharacterDetailView(character: PreviewData.sampleCharacter)
    }
}
