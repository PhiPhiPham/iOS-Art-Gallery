//
//  YearFilterSheet.swift
//  iOS-Art-Gallery
//
//  Created by Codex on 25/11/2025.
//

import SwiftUI

struct YearFilterSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var startText: String
    @State private var endText: String

    let onApply: (YearRange) -> Void

    init(initialRange: YearRange, onApply: @escaping (YearRange) -> Void) {
        _startText = State(initialValue: initialRange.startYear.map(String.init) ?? "")
        _endText = State(initialValue: initialRange.endYear.map(String.init) ?? "")
        self.onApply = onApply
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Year range") {
                    TextField("From", text: $startText)
                        .keyboardType(.numberPad)
                    TextField("To", text: $endText)
                        .keyboardType(.numberPad)
                    Text(rangeDescription)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Section {
                    Button("Clear Filter", role: .destructive, action: clear)
                        .disabled(startText.isEmpty && endText.isEmpty)
                }
            }
            .navigationTitle("Filter by Year")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", action: close)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply", action: apply)
                        .disabled(!isValidInput)
                }
            }
        }
    }

    private var isValidInput: Bool {
        (startText.isEmpty || Int(startText) != nil) && (endText.isEmpty || Int(endText) != nil)
    }

    private var rangeDescription: String {
        "Current selection: \(normalizedRange.description)"
    }

    private var normalizedRange: YearRange {
        var start = Int(startText)
        var end = Int(endText)
        if let s = start, let e = end, s > e {
            swap(&start, &end)
        }
        return YearRange(startYear: start, endYear: end)
    }

    private func apply() {
        onApply(normalizedRange)
        dismiss()
    }

    private func clear() {
        startText = ""
        endText = ""
        onApply(YearRange())
        dismiss()
    }

    private func close() {
        dismiss()
    }
}
