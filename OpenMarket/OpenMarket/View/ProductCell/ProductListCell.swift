//
//  ProductListCell.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/04.
//

import UIKit

class ProductListCell: ProductCellBase, ProductCellLayoutDelegate {

    static let reuseIdentifier = "ProductListCell"

    private var titleStockLabelStack: UIStackView!
    private var priceLabelsStack: UIStackView!
    private var labelStack: UIStackView!
    private var mainStack: UIStackView!

    override func setLayoutDelegate() {
        layoutDelegate = self
    }

    func configureHierarchy() {
        titleStockLabelStack = UIStackView(arrangedSubviews: [nameLabel, stockLabel, showDetailMark])
        titleStockLabelStack.axis = .horizontal
        titleStockLabelStack.distribution = .fill
        titleStockLabelStack.spacing = UIStackView.spacingUseSystem
        stockLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        showDetailMark.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        priceLabelsStack = UIStackView(arrangedSubviews: [priceLabel, discountedPriceLabel])
        priceLabelsStack.axis = .horizontal
        priceLabelsStack.distribution = .fill
        priceLabelsStack.spacing = UIStackView.spacingUseSystem
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        priceLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        labelStack = UIStackView(arrangedSubviews: [titleStockLabelStack, priceLabelsStack])
        labelStack.axis = .vertical
        labelStack.distribution = .equalSpacing
        labelStack.alignment = .fill
        labelStack.spacing = 10
        labelStack.setContentHuggingPriority(.defaultLow, for: .horizontal)

        mainStack = UIStackView(arrangedSubviews: [imageView, labelStack])
        mainStack.axis = .horizontal
        mainStack.distribution = .fill
        mainStack.alignment = .center
        mainStack.spacing = 10
        self.addSubview(mainStack)
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0)
        ])

        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: self.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

#if DEBUG
import SwiftUI

struct ProductListCell_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let previewCell = ProductListCell()
            previewCell.imageView.image = UIImage(systemName: "square")
            let product = Product(id: 0, vendorID: 0, name: "상품", thumbnail: "",
                                  currency: .koreanWon, price: 10.0, bargainPrice: 10.0,
                                  discountedPrice: 90.0, stock: 10, createdAt: "",
                                  issuedAt: "", images: nil, vendor: nil)
            previewCell.updateContent(product: product)
            return previewCell
        }.previewDevice(PreviewDevice(rawValue: "iPhone 11"))
    }
}
#endif
