import SwiftUI

struct CategoryMenuCard: View {
    let category: PotterCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: category.systemIconName)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.white)
                .padding(10)
                .background(category.accentColor.opacity(0.3), in: Circle())
            Text(category.title)
                .font(.headline)
                .foregroundStyle(.white)
            Text(category.tagline)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
                .lineLimit(2)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(category.backgroundGradient)
        .cornerRadius(20)
        .shadow(color: category.accentColor.opacity(0.35), radius: 8, x: 0, y: 8)
    }
}

#Preview {
    CategoryMenuCard(category: .books)
        .padding()
}
