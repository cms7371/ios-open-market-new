//
//  JsonParser.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

class JSONConverter {

    private init() { }
    static let shared = JSONConverter()

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    func decode<T: Decodable>(from jsonData: Data) throws -> T {
        return try decoder.decode(T.self, from: jsonData)
    }
}
