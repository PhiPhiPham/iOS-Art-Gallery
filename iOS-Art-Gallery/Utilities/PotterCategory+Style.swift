import SwiftUI

extension PotterCategory {
    var accentColor: Color {
        switch self {
        case .books: return Color(red: 0.53, green: 0.31, blue: 0.78)
        case .characters: return Color(red: 0.20, green: 0.45, blue: 0.84)
        case .movies: return Color(red: 0.93, green: 0.44, blue: 0.30)
        case .potions: return Color(red: 0.00, green: 0.62, blue: 0.52)
        case .spells: return Color(red: 0.96, green: 0.76, blue: 0.20)
        }
    }

    var backgroundGradient: LinearGradient {
        LinearGradient(colors: [accentColor.opacity(0.2), accentColor], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
