import Combine
import Foundation

@MainActor
final class BookDetailViewModel: ObservableObject {
    @Published private(set) var book: PotterBook
    @Published private(set) var chapters: [PotterChapter] = []
    @Published private(set) var detailState: ViewState = .idle
    @Published private(set) var chaptersState: ViewState = .idle
    @Published var alertMessage: String?
    @Published var isAlertVisible = false

    private let service: PotterServicing
    private var detailTask: Task<Void, Never>?
    private var chaptersTask: Task<Void, Never>?

    init(book: PotterBook, service: PotterServicing = PotterService()) {
        self.book = book
        self.service = service
    }

    deinit {
        detailTask?.cancel()
        chaptersTask?.cancel()
    }

    func load() {
        fetchDetail()
        fetchChapters()
    }

    func refresh() {
        fetchDetail()
        fetchChapters()
    }

    private func fetchDetail() {
        detailTask?.cancel()
        detailState = .loading
        let id = book.id
        detailTask = Task { [weak self] in
            guard let self else { return }
            do {
                let detail = try await service.fetchBookDetail(id: id)
                await MainActor.run {
                    self.book = detail
                    self.detailState = .loaded
                }
            } catch {
                await MainActor.run {
                    self.detailState = .error(message: self.message(from: error))
                    self.presentAlert(message: self.message(from: error))
                }
            }
        }
    }

    private func fetchChapters() {
        chaptersTask?.cancel()
        chaptersState = .loading
        let id = book.id
        chaptersTask = Task { [weak self] in
            guard let self else { return }
            do {
                let chapters = try await service.fetchChapters(bookID: id)
                await MainActor.run {
                    self.chapters = chapters
                    self.chaptersState = chapters.isEmpty ? .empty(message: "No chapters were published for this book.") : .loaded
                }
            } catch {
                await MainActor.run {
                    self.chaptersState = .error(message: self.message(from: error))
                    self.presentAlert(message: self.message(from: error))
                }
            }
        }
    }

    private func message(from error: Error) -> String {
        if let localized = error as? LocalizedError, let description = localized.errorDescription {
            return description
        }
        return "Something went wrong. Please try again."
    }

    private func presentAlert(message: String) {
        alertMessage = message
        isAlertVisible = true
    }
}
