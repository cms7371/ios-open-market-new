//
//  MarketAPITest.swift
//  OpenMarketTests
//
//  Created by kakao on 2022/01/25.
//

import Foundation
import XCTest
@testable import OpenMarket

class MarketAPITests: XCTestCase {
    func testGetProducts() throws {
        // given
        var result: [Product]?
        let expectation = XCTestExpectation(description: "GetProductsExpectation")
        // when
        MarketAPI.getProducts(pageNumber: 1) { products in
            result = products
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        // then
        XCTAssertNotNil(result)
        // check
        print(result as Any)
    }

    func testGetProduct() throws {
        // given
        var result: Product?
        let expectation = XCTestExpectation(description: "GetProductExpectation")
        // when
        MarketAPI.getProduct(id: 1000) { product in
            result = product
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        // then
        XCTAssertNotNil(result)
        // check
        print(result as Any)
    }
}
