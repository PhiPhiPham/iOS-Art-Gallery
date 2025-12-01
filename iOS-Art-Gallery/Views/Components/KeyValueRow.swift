import SwiftUI

struct KeyValueRow: View {
    let key: String
    let value: String?

    var body: some View {
        HStack(alignment: .top) {
            Text(key)
                .font(.subheadline.bold())
                .frame(width: 120, alignment: .leading)
            Text(value?.isEmpty == false ? value! : "Unknown")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    VStack(alignment: .leading) {
        KeyValueRow(key: "House", value: "Gryffindor")
        KeyValueRow(key: "House", value: nil)
    }
    .padding()
}
