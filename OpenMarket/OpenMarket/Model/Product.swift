//
//  Product.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation
import CoreText

struct Product: Decodable, Hashable {

    let id: Int
    let vendorID: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Float
    let bargainPrice: Float
    let discountedPrice: Float
    let stock: Int
    let createdAt: String
    let issuedAt: String
    let images: [ProductImage]?
    let vendor: Vendor?

    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case images
        case vendor
    }

    enum Currency: String, Decodable {
        case koreanWon = "KRW"
        case usDollar = "USD"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
