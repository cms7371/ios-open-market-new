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
        var result: Data?
        let expectation = XCTestExpectation(description: "GetProductsExpectation")
        // when
        MarketAPI.getProducts(pageNumber: 1) { productsData in
            result = productsData
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        // then
        XCTAssertNotNil(result)
        XCTAssertNoThrow {
            try JSONCoder.shared.decode(from: result!) as [Product]
        }
    }

    func testGetProduct() throws {
        // given
        var result: Data?
        let expectation = XCTestExpectation(description: "GetProductExpectation")
        // when
        MarketAPI.getProduct(id: 1000) { productData in
            result = productData
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        // then
        XCTAssertNotNil(result)
        XCTAssertNoThrow {
            try JSONCoder.shared.decode(from: result!) as Product
        }
    }
}
