//
//  Int+extension.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/04.
//

import Foundation

extension Float {
    func toPriceForm(currency: Product.Currency) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let numberWithCommas = numberFormatter.string(from: NSNumber(value: self)) ?? ""
        return "\(currency.rawValue) \(numberWithCommas)"
    }
}
