//
//  ProductListCell.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/03.
//

import UIKit
import CoreData

class ProductCellBase: UICollectionViewCell {

    weak var layoutDelegate: ProductCellLayoutDelegate?

    func setLayoutDelegate() {
        fatalError("ProductBaseCell: setLayoutDelegate must be overriden")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContent()
        setLayoutDelegate()
        layoutDelegate?.configureHierarchy()
        layoutDelegate?.configureConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    var thumbnailImageView: UIImageView!
    var loadingIndicatorView: UIActivityIndicatorView!
    var nameLabel: UILabel!
    var priceLabel: UILabel!
    var discountedPriceLabel: UILabel!
    var stockLabel: UILabel!
    var showDetailMark: UIImageView!

    func configureContent() {
        thumbnailImageView = UIImageView()
        loadingIndicatorView = UIActivityIndicatorView(style: .medium)
        loadingIndicatorView.hidesWhenStopped = true
        loadingIndicatorView.startAnimating()
        nameLabel = UILabel()
        nameLabel.numberOfLines = 1
        priceLabel = UILabel()
        discountedPriceLabel = UILabel()
        discountedPriceLabel.isHidden = true
        stockLabel = UILabel()
        showDetailMark = UIImageView(image: UIImage.init(systemName: "chevron.right"))
        nameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        [priceLabel, discountedPriceLabel, stockLabel].forEach {
            $0?.font = UIFont.preferredFont(forTextStyle: .body)
            $0?.textColor = UIColor.gray
        }
        showDetailMark.tintColor = .opaqueSeparator
    }

    func updateContent(product: Product) {
        nameLabel.text = product.name
        if product.stock > 0 {
            stockLabel.text = "잔여수량 : \(product.stock)"
        } else {
            stockLabel.text = "품절"
            stockLabel.textColor = .orange
        }
        let attributedPriceString =
            NSMutableAttributedString(string: product.price.toPriceForm(currency: product.currency))
        if product.bargainPrice > 0 {
            discountedPriceLabel.isHidden = false
            discountedPriceLabel.text = product.discountedPrice.toPriceForm(currency: product.currency)
            attributedPriceString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                               value: NSUnderlineStyle.single.rawValue,
                                               range: NSRange(0..<attributedPriceString.length))
            attributedPriceString.addAttribute(NSAttributedString.Key.foregroundColor,
                                               value: UIColor.red,
                                               range: NSRange(0..<attributedPriceString.length))
        }
        priceLabel.attributedText = attributedPriceString
    }

    func setThumbnailImage(_ image: UIImage) {
        loadingIndicatorView.stopAnimating()
        thumbnailImageView.image = image
    }

    override func prepareForReuse() {
        loadingIndicatorView.startAnimating()
        thumbnailImageView.image = nil
        stockLabel.textColor = .gray
        discountedPriceLabel.isHidden = true
    }
}
