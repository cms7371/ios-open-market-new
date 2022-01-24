//
//  Vendor.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

struct Vendor: Decodable {
    let name: String
    let id: Int
    let createdAt: String
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
