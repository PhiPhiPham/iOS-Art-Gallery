//
//  PreviewData.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import SwiftUI

enum PreviewData {
    static let sampleArtwork = Artwork(
        id: 27992,
        title: "Water Lilies",
        artistTitle: "Claude Monet",
        artistDisplay: "Claude Monet was a founder of French Impressionism.",
        artistDisplayBio: "French, 1840-1926",
        dateDisplay: "1905",
        dateStart: 1905,
        dateEnd: 1905,
        placeOfOrigin: "France",
        mediumDisplay: "Oil on canvas",
        dimensions: "100 × 200 cm",
        creditLine: "Gift of the Artist",
        artworkTypeTitle: "Painting",
        departmentTitle: "European Painting",
        publicationHistory: "Exhibited around the world.",
        imageId: "123",
        thumbnail: nil,
        apiModel: nil,
        artworkTypeId: nil,
        artistIds: nil,
        termTitles: ["Impressionism"],
        styleTitles: ["Impressionism"],
        subjectTitles: ["Water", "Nature"],
        materialTitles: ["Oil", "Canvas"],
        dateUpdated: nil,
        isPublicDomain: true
    )
}

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(_ initialValue: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
