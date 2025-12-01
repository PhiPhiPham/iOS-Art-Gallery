import Foundation

struct PotterListResponse<T: Decodable>: Decodable {
    let data: [T]
    let meta: PotterMeta?
}

struct PotterSingleResponse<T: Decodable>: Decodable {
    let data: T
}

struct PotterMeta: Decodable {
    let pagination: PotterPagination?
}

struct PotterPagination: Decodable {
    let current: Int?
    let next: Int?
    let last: Int?
    let records: Int?

    var canLoadMore: Bool {
        if let next, next > 0 { return true }
        guard let current, let last else { return false }
        return current < last
    }
}
