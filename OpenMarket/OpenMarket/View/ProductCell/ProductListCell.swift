//
//  ProductListCell.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/04.
//

import UIKit

class ProductListCell: ProductCellBase {

    static let reuseIdentifier = "ProductListCell"

    private let titleStockLabelStack =  UIStackView()
    private let priceLabelsStack =  UIStackView()
    private let labelStack =  UIStackView()
    private let mainStack =  UIStackView()
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray4
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureHierarchy() {
        [nameLabel, stockLabel, showDetailMark].forEach { titleStockLabelStack.addArrangedSubview($0) }
        titleStockLabelStack.axis = .horizontal
        titleStockLabelStack.distribution = .fill
        titleStockLabelStack.alignment = .center
        titleStockLabelStack.spacing = UIStackView.spacingUseSystem
        stockLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        showDetailMark.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        [priceLabel, discountedPriceLabel].forEach { priceLabelsStack.addArrangedSubview($0) }
        priceLabelsStack.axis = .horizontal
        priceLabelsStack.distribution = .fill
        priceLabelsStack.spacing = UIStackView.spacingUseSystem
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        priceLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        [titleStockLabelStack, priceLabelsStack].forEach { labelStack.addArrangedSubview($0) }
        labelStack.axis = .vertical
        labelStack.distribution = .equalSpacing
        labelStack.alignment = .fill
        labelStack.spacing = 10
        labelStack.setContentHuggingPriority(.defaultLow, for: .horizontal)

        [thumbnailImageView, labelStack].forEach { mainStack.addArrangedSubview($0) }
        mainStack.axis = .horizontal
        mainStack.distribution = .fill
        mainStack.alignment = .center
        mainStack.spacing = 10

        self.addSubview(mainStack)
        self.addSubview(loadingIndicatorView)
        self.addSubview(separator)
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor)
        ])

        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicatorView.centerXAnchor.constraint(equalTo: thumbnailImageView.centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor)
        ])

        showDetailMark.heightAnchor.constraint(equalToConstant: 20).isActive = true

        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: self.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

#if DEBUG
import SwiftUI

struct ProductListCell_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let previewCell = ProductListCell()
            previewCell.thumbnailImageView.image = UIImage(systemName: "square")
            let product = Product(id: 0, vendorID: 0, name: "상품", thumbnailURLString: "",
                                  currency: .koreanWon, price: 10.0, bargainPrice: 10.0,
                                  discountedPrice: 90.0, stock: 10, createdAt: "",
                                  issuedAt: "", images: nil, vendor: nil)
            previewCell.updateContent(product: product, indexPath: IndexPath())
            return previewCell
        }.previewDevice(PreviewDevice(rawValue: "iPhone 11"))
    }
}
#endif
