//
//  ContentView.swift
//  iOS-Art-Gallery
//
//  Created by Phi Phi Pham on 25/11/2025.
//

import SwiftUI

@MainActor
struct ContentView: View {
    @StateObject private var viewModel: GalleryViewModel
    @State private var isFilterPresented = false

    init(viewModel: GalleryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                SearchBarView(
                    text: $viewModel.searchText,
                    onSubmit: viewModel.submitSearch,
                    onClear: viewModel.clearSearch
                )
                .onChange(of: viewModel.searchText) { _, newValue in
                    viewModel.updateSearch(text: newValue)
                }

                filterSummary

                content
                    .animation(.easeInOut, value: viewModel.state)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationTitle("Art Gallery")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isFilterPresented = true
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $isFilterPresented) {
                YearFilterSheet(initialRange: viewModel.yearRange) { range in
                    viewModel.apply(yearRange: range)
                }
                .presentationDetents([.medium])
            }
            .alert("Art Gallery", isPresented: $viewModel.isAlertVisible) {
                Button("Dismiss", role: .cancel) { }
                Button("Retry") {
                    viewModel.refresh()
                }
            } message: {
                Text(viewModel.alertMessage ?? "Something went wrong.")
            }
            .navigationDestination(for: Artwork.self) { artwork in
                ArtworkDetailView(artwork: artwork)
            }
        }
        .task {
            viewModel.loadInitial()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loaded:
            artworksList
        case .loading:
            if viewModel.artworks.isEmpty {
                ProgressView("Loading artworks…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                artworksList
            }
        case .empty(let message):
            StatePlaceholderView(kind: .empty, title: "No Artworks", message: message, actionTitle: "Reset Filters") {
                viewModel.clearSearch()
                viewModel.clearYearFilter()
            }
        case .error(let message):
            StatePlaceholderView(kind: .error, title: "Something went wrong", message: message, actionTitle: "Retry") {
                viewModel.refresh()
            }
        }
    }

    private var artworksList: some View {
        List {
            Section {
                ForEach(viewModel.artworks) { artwork in
                    NavigationLink(value: artwork) {
                        ArtworkRowView(artwork: artwork)
                    }
                    .buttonStyle(.plain)
                    .onAppear {
                        viewModel.loadMoreIfNeeded(current: artwork)
                    }
                }
                if viewModel.isLoadingMore {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.refreshAsync()
        }
    }

    @ViewBuilder
    private var filterSummary: some View {
        if !viewModel.yearRange.isEmpty || !viewModel.searchText.isEmpty {
            HStack {
                Label {
                    VStack(alignment: .leading, spacing: 2) {
                        if !viewModel.searchText.isEmpty {
                            Text("Search: \(viewModel.searchText)")
                                .font(.subheadline)
                        }
                        if !viewModel.yearRange.isEmpty {
                            Text("Year: \(viewModel.yearRange.description)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                } icon: {
                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
                        .foregroundStyle(.blue)
                }
                Spacer()
                Button("Clear", role: .cancel) {
                    viewModel.clearSearch()
                    viewModel.clearYearFilter()
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
        }
    }
}

#Preview("Loaded") {
    NavigationStack {
        ContentView(viewModel: .previewLoaded)
    }
}

#Preview("Empty") {
    NavigationStack {
        ContentView(viewModel: .previewEmpty)
    }
}
