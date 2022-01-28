//
//  JsonDecodingTests.swift
//  OpenMarketTests
//
//  Created by kakao on 2022/01/24.
//

import Foundation
import XCTest
@testable import OpenMarket

class JsonDecodeingTests: XCTestCase {
    func testDecodingProductWithVenderAndImage() throws {
        // given and when
        let jsonData = NSDataAsset(name: "json_productExample")!.data
        // then
        XCTAssertNoThrow(try JSONCoder.shared.decode(from: jsonData) as Product)
        // check
        let product: Product = try JSONCoder.shared.decode(from: jsonData)
        print(product)
    }

    func testDecodingPageWithProducts() throws {
        // given and when
        let jsonData = NSDataAsset(name: "json_pageExample")!.data
        // then
        XCTAssertNoThrow(try JSONCoder.shared.decode(from: jsonData) as Page<Product>)
        // check
        let page: Page<Product> = try JSONCoder.shared.decode(from: jsonData)
        print(page)
    }
}
