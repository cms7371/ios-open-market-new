//
//  MarketAPI.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/25.
//

import Foundation

class MarketAPI {
    private init() { }

    static let baseURL = "https://market-training.yagom-academy.kr"
    static let basePath = ["api", "products"]

    static func getProducts(pageNumber: Int, itemCount: Int = 20, completionUIHandler: @escaping ([Product]) -> Void) {
        HTTPManager.get(url: baseURL, path: basePath,
                        query: ["page_no": pageNumber, "items_per_page": itemCount]) { jsonData in
            do {
                let fetchedPage: Page<Product> = try JSONCoder.shared.decode(from: jsonData)
                DispatchQueue.main.async {
                    completionUIHandler(fetchedPage.items)
                }
            } catch {
                print("MarketAPI: Failed decoding page of products JSON")
            }
        }
    }

    static func getProduct(id: Int, completionUIHandler: @escaping (Product) -> Void) {
        HTTPManager.get(url: baseURL, path: basePath + ["\(id)"], query: nil) { jsonData in
            do {
                let fetchedProduct: Product = try JSONCoder.shared.decode(from: jsonData)
                DispatchQueue.main.async {
                    completionUIHandler(fetchedProduct)
                }
            } catch {
                print("MarketAPI: Failed decoding product JSON")
            }
        }
    }
}
