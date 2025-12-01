import SwiftUI

struct BookDetailView: View {
    @StateObject private var viewModel: BookDetailViewModel

    init(book: PotterBook) {
        _viewModel = StateObject(wrappedValue: BookDetailViewModel(book: book))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                heroSection
                infoSection
                if let summary = viewModel.book.summary, !summary.isEmpty {
                    detailCard(title: "Summary", value: summary)
                }
                if let dedication = viewModel.book.dedication, !dedication.isEmpty {
                    detailCard(title: "Dedication", value: dedication)
                }
                chaptersSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.book.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.refresh()
                } label: {
                    Label("Reload", systemImage: "arrow.clockwise")
                }
            }
        }
        .alert("Potter Wiki", isPresented: $viewModel.isAlertVisible) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage ?? "")
        }
        .task {
            viewModel.load()
        }
    }

    @ViewBuilder
    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: viewModel.book.coverURL) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 10)
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .frame(height: 220)
                        ProgressView()
                    }
                case .failure:
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .frame(height: 220)
                        .overlay {
                            Image(systemName: "book")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            Text(viewModel.book.author ?? "Unknown author")
                .font(.title3)
                .bold()
            HStack(spacing: 12) {
                Label(viewModel.book.releaseDateText, systemImage: "calendar")
                if let pages = viewModel.book.pages {
                    Label("\(pages) pages", systemImage: "text.book.closed")
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Details")
                .font(.headline)
            VStack(spacing: 0) {
                KeyValueRow(key: "Author", value: viewModel.book.author)
                KeyValueRow(key: "Release", value: viewModel.book.releaseDate)
                KeyValueRow(key: "Pages", value: viewModel.book.pages.map { "\($0)" })
                if let url = viewModel.book.wikiURL {
                    Divider()
                    Link(destination: url) {
                        Label("Read on the wiki", systemImage: "link")
                            .font(.subheadline.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(.background))
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        }
    }

    @ViewBuilder
    private var chaptersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Chapters")
                .font(.headline)
            switch viewModel.chaptersState {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            case .empty(let message):
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            case .error(let message):
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            default:
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.chapters) { chapter in
                        chapterCard(chapter)
                    }
                }
            }
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

    private func chapterCard(_ chapter: PotterChapter) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(chapter.order.map { "Chapter \($0)" } ?? "Chapter")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            Text(chapter.title)
                .font(.headline)
            Text(chapter.summary ?? "No summary available")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    NavigationStack {
        BookDetailView(book: PreviewData.sampleBook)
    }
}
