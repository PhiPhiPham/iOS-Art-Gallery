//
//  StatePlaceholderView.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import SwiftUI

struct StatePlaceholderView: View {
    enum Kind {
        case empty
        case error
    }

    let kind: Kind
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: 42))
                .foregroundStyle(kind == .error ? .pink : .secondary)
            Text(title)
                .font(.title3.bold())
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    private var iconName: String {
        switch kind {
        case .empty: return "sparkles"
        case .error: return "exclamationmark.triangle"
        }
    }
}

#Preview {
    StatePlaceholderView(kind: .empty, title: "No Content", message: "Try another search")
}
