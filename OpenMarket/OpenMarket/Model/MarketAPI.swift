//
//  MarketAPI.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/25.
//

import Foundation

struct MarketAPI {
    private init() { }

    static let baseURL = "https://market-training.yagom-academy.kr"
    static let basePath = ["api", "products"]

    static func getProducts(pageNumber: Int, itemCount: Int = 20, completionHandler: @escaping (Data) -> Void) {
        HTTPManager.get(url: baseURL, path: basePath, query: ["page_no": pageNumber, "items_per_page": itemCount],
                        completionHandler: completionHandler)
    }

    static func getProduct(id: Int, completionUIHandler: @escaping (Data) -> Void) {
        HTTPManager.get(url: baseURL, path: basePath + ["\(id)"], query: nil, completionHandler: completionUIHandler)
    }
}
