//
//  ProductGridCell.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/04.
//

import UIKit

class ProductGridCell: ProductCellBase, ProductCellLayoutDelegate {

    static var reuseIdentifier: String = "ProductGridCell"

    var mainStack: UIStackView!
    var pricesStack: UIStackView!

    override func setLayoutDelegate() {
        layoutDelegate = self
    }

    func configureHierarchy() {
        pricesStack = UIStackView(arrangedSubviews: [priceLabel, discountedPriceLabel])
        pricesStack.axis = .vertical
        pricesStack.distribution = .fillEqually
        pricesStack.alignment = .center

        mainStack = UIStackView(arrangedSubviews: [imageView, nameLabel, pricesStack, stockLabel])
        mainStack.axis = .vertical
        mainStack.distribution = .equalSpacing
        mainStack.spacing = 8
        mainStack.alignment = .center

        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 5
        self.addSubview(mainStack)
    }

    func configureConstraints() {
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6).isActive = true
        let imageViewHeightConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor,
                                                                          multiplier: 1.0)
        imageViewHeightConstraint.isActive = true
        imageViewHeightConstraint.priority = .defaultHigh
        pricesStack.heightAnchor.constraint(equalToConstant: 50).isActive = true

        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
}

#if DEBUG
import SwiftUI

struct ProductGridCell_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let previewCell = ProductGridCell()
            previewCell.imageView.image = UIImage(systemName: "square")
            let product = Product(id: 0, vendorID: 0, name: "상품", thumbnail: "",
                                  currency: .koreanWon, price: 1000.0, bargainPrice: 10.0,
                                  discountedPrice: 90.0, stock: 10, createdAt: "",
                                  issuedAt: "", images: nil, vendor: nil)
            previewCell.updateContent(product: product)
            return previewCell
        }.previewLayout(.sizeThatFits)
    }
}
#endif
