//
//  ProductCellLayoutDelegate.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/04.
//

import Foundation

protocol ProductCellLayoutDelegate: AnyObject {

    static var reuseIdentifier: String { get }

    func configureHierarchy()
    func configureConstraints()
}
