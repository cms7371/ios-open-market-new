//
//  Page.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

struct Page<T: Decodable>: Decodable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPageNumber: Int
    let hasPrev: Bool
    let hasNext: Bool
    let items: [T]
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset
        case limit
        case lastPageNumber = "last_page"
        case hasPrev = "has_prev"
        case hasNext = "has_next"
        case items = "pages"
    }
}
