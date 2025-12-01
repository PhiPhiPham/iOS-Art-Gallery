import Foundation

protocol PotterServicing {
    func fetchBooks(page: Int, pageSize: Int) async throws -> PotterPage<PotterBook>
    func fetchBookDetail(id: String) async throws -> PotterBook
    func fetchChapters(bookID: String) async throws -> [PotterChapter]
    func fetchMovies(page: Int, pageSize: Int) async throws -> PotterPage<PotterMovie>
    func fetchCharacters(page: Int, pageSize: Int, ascending: Bool) async throws -> PotterPage<PotterCharacter>
    func fetchPotions(page: Int, pageSize: Int) async throws -> PotterPage<PotterPotion>
    func fetchSpells(page: Int, pageSize: Int) async throws -> PotterPage<PotterSpell>
    func fetchRecommendation() async throws -> PotterRecommendation
}

struct PotterPage<Item: Hashable>: Equatable {
    let items: [Item]
    let canLoadMore: Bool
}

final class PotterService: PotterServicing {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func fetchBooks(page: Int, pageSize: Int) async throws -> PotterPage<PotterBook> {
        try await paginatedRequest(category: .books, page: page, pageSize: pageSize)
    }

    func fetchBookDetail(id: String) async throws -> PotterBook {
        let endpoint = PotterEndpoint.bookDetail(id: id)
        let response: PotterSingleResponse<PotterBook> = try await request(endpoint)
        return response.data
    }

    func fetchChapters(bookID: String) async throws -> [PotterChapter] {
        let endpoint = PotterEndpoint.bookChapters(id: bookID)
        let response: PotterListResponse<PotterChapter> = try await request(endpoint)
        return response.data
    }

    func fetchMovies(page: Int, pageSize: Int) async throws -> PotterPage<PotterMovie> {
        try await paginatedRequest(category: .movies, page: page, pageSize: pageSize)
    }

    func fetchCharacters(page: Int, pageSize: Int, ascending: Bool) async throws -> PotterPage<PotterCharacter> {
        let sort = ascending ? "name" : "-name"
        var pageData: PotterPage<PotterCharacter> = try await paginatedRequest(
            category: .characters,
            page: page,
            pageSize: pageSize,
            sort: sort
        )
        pageData = PotterPage(items: pageData.items.sorted { lhs, rhs in
            let comparison = lhs.name.localizedCaseInsensitiveCompare(rhs.name)
            return ascending ? comparison == .orderedAscending : comparison == .orderedDescending
        }, canLoadMore: pageData.canLoadMore)
        return pageData
    }

    func fetchPotions(page: Int, pageSize: Int) async throws -> PotterPage<PotterPotion> {
        try await paginatedRequest(category: .potions, page: page, pageSize: pageSize)
    }

    func fetchSpells(page: Int, pageSize: Int) async throws -> PotterPage<PotterSpell> {
        try await paginatedRequest(category: .spells, page: page, pageSize: pageSize)
    }

    func fetchRecommendation() async throws -> PotterRecommendation {
        for category in PotterCategory.allCases.shuffled() {
            if let recommendation = try await randomRecommendation(in: category) {
                return recommendation
            }
        }
        throw APIError.emptyData
    }

    private func randomRecommendation(in category: PotterCategory) async throws -> PotterRecommendation? {
        switch category {
        case .books:
            let page = try await fetchBooks(page: 1, pageSize: category.defaultPageSize)
            guard let item = page.items.randomElement() else { return nil }
            return .book(item)
        case .movies:
            let page = try await fetchMovies(page: 1, pageSize: category.defaultPageSize)
            guard let item = page.items.randomElement() else { return nil }
            return .movie(item)
        case .characters:
            let page = try await fetchCharacters(page: 1, pageSize: category.defaultPageSize, ascending: true)
            guard let item = page.items.randomElement() else { return nil }
            return .character(item)
        case .potions:
            let page = try await fetchPotions(page: 1, pageSize: category.defaultPageSize)
            guard let item = page.items.randomElement() else { return nil }
            return .potion(item)
        case .spells:
            let page = try await fetchSpells(page: 1, pageSize: category.defaultPageSize)
            guard let item = page.items.randomElement() else { return nil }
            return .spell(item)
        }
    }

    private func paginatedRequest<T: Decodable & Hashable>(category: PotterCategory, page: Int, pageSize: Int, sort: String? = nil) async throws -> PotterPage<T> {
        let endpoint = PotterEndpoint.list(category: category, page: page, pageSize: pageSize, sort: sort)
        let response: PotterListResponse<T> = try await request(endpoint)
        let canLoadMore = response.meta?.pagination?.canLoadMore ?? false
        return PotterPage(items: response.data, canLoadMore: canLoadMore)
    }

    private func request<T: Decodable>(_ endpoint: PotterEndpoint) async throws -> T {
        do {
            let (data, response) = try await session.data(for: endpoint.makeRequest())
            guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
                throw APIError.invalidResponse
            }
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decoding(error)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.transport(error)
        }
    }
}
