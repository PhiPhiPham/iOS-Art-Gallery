import SwiftUI

struct RecommendationCard: View {
    let recommendation: PotterRecommendation

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Today's recommendation")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.9))
                    Text(recommendation.title)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .lineLimit(2)
                }
                Spacer()
                Image(systemName: recommendation.category.systemIconName)
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.8))
            }

            HStack(alignment: .top, spacing: 16) {
                AsyncImage(url: recommendation.imageURL) { phase in
                    switch phase {
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    case .empty:
                        placeholder
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(recommendation.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(1)
                    Text(recommendation.description)
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(4)
                }
                Spacer()
            }
        }
        .padding()
        .background(recommendation.category.backgroundGradient)
        .cornerRadius(24)
        .shadow(color: recommendation.category.accentColor.opacity(0.35), radius: 12, x: 0, y: 12)
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(.white.opacity(0.2))
            .frame(width: 90, height: 90)
            .overlay {
                Image(systemName: "wand.and.stars")
                    .foregroundStyle(.white.opacity(0.8))
            }
    }
}

#Preview {
    RecommendationCard(recommendation: .book(PreviewData.sampleBook))
        .padding()
}
