import Foundation

enum PotterEndpoint {
    case list(category: PotterCategory, page: Int, pageSize: Int, sort: String? = nil)
    case bookDetail(id: String)
    case bookChapters(id: String)

    func makeRequest() throws -> URLRequest {
        let baseURL = URL(string: "https://api.potterdb.com/v1")!
        let url = baseURL.appending(path: path)
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        components.queryItems = queryItems
        guard let finalURL = components.url else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: finalURL)
        request.timeoutInterval = 20
        return request
    }

    private var path: String {
        switch self {
        case let .list(category, _, _, _):
            return category.path
        case let .bookDetail(id):
            return "/books/\(id)"
        case let .bookChapters(id):
            return "/books/\(id)/chapters"
        }
    }

    private var queryItems: [URLQueryItem]? {
        switch self {
        case let .list(_, page, pageSize, sort):
            var items = [
                URLQueryItem(name: "page[number]", value: String(page)),
                URLQueryItem(name: "page[size]", value: String(pageSize))
            ]
            if let sort, !sort.isEmpty {
                items.append(URLQueryItem(name: "sort", value: sort))
            }
            return items
        case .bookDetail:
            return nil
        case .bookChapters:
            return [URLQueryItem(name: "page[size]", value: "50")]
        }
    }
}
