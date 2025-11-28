//
//  SearchBarView.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var placeholder: String = "Search artworks"
    var onSubmit: () -> Void
    var onClear: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .onSubmit(onSubmit)
            if !text.isEmpty {
                Button {
                    onClear()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    StatefulPreviewWrapper("Monet") { value in
        SearchBarView(text: value, onSubmit: {}, onClear: {})
            .padding()
    }
}
