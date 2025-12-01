import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var recommendation: PotterRecommendation?
    @Published private(set) var recommendationState: ViewState = .idle
    @Published var alertMessage: String?
    @Published var isAlertVisible = false

    let menuItems = PotterCategory.allCases

    private let service: PotterServicing
    private var recommendationTask: Task<Void, Never>?

    init(service: PotterServicing = PotterService()) {
        self.service = service
    }

    deinit {
        recommendationTask?.cancel()
    }

    func loadIfNeeded() {
        guard recommendation == nil else { return }
        fetchRecommendation()
    }

    func fetchRecommendation() {
        recommendationTask?.cancel()
        recommendationState = .loading
        recommendationTask = Task { [weak self] in
            guard let self else { return }
            do {
                let recommendation = try await service.fetchRecommendation()
                await MainActor.run {
                    self.recommendation = recommendation
                    self.recommendationState = .loaded
                }
            } catch {
                await MainActor.run {
                    self.recommendationState = .error(message: self.message(from: error))
                    self.presentAlert(message: self.message(from: error))
                }
            }
        }
    }

    private func message(from error: Error) -> String {
        if let localized = error as? LocalizedError, let description = localized.errorDescription {
            return description
        }
        return "We couldn't load today's recommendation."
    }

    private func presentAlert(message: String) {
        alertMessage = message
        isAlertVisible = true
    }
}

#if DEBUG
extension HomeViewModel {
    @MainActor
    static func preview(recommendation: PotterRecommendation) -> HomeViewModel {
        let viewModel = HomeViewModel()
        viewModel.recommendation = recommendation
        viewModel.recommendationState = .loaded
        return viewModel
    }
}
#endif
