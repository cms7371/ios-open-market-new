//
//  ProductImage.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

struct ProductImage: Decodable {
    let id: Int
    let urlString: String
    let thumbnailURLString: String
    let succeed: Bool
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case urlString = "url"
        case thumbnailURLString = "thumbnail_url"
        case succeed
        case issuedAt = "issued_at"
    }
}
