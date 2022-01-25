//
//  JsonParser.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

class JSONCoder {

    private init() { }
    static let shared = JSONCoder()

    private let decoder = JSONDecoder()

    func decode<T: Decodable>(from jsonData: Data) throws -> T {
        return try decoder.decode(T.self, from: jsonData)
    }
}
