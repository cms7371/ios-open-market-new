//
//  ProductListCell.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/03.
//

import UIKit
import CoreData

class ProductCellBase: UICollectionViewCell {

    var thumbnailImageView: UIImageView = UIImageView()
    var loadingIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()

    var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = UIColor.gray
        return label
    }()

    var discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = UIColor.gray
        label.isHidden = true
        return label
    }()

    var stockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = UIColor.gray
        return label
    }()

    var showDetailMark: UIImageView = {
        let imageView = UIImageView(image: UIImage.init(systemName: "chevron.right"))
        imageView.tintColor = .opaqueSeparator
        return imageView
    }()

    var indexPath: IndexPath?

    func updateContent(product: Product, indexPath: IndexPath) {
        self.indexPath = indexPath
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

    func setThumbnailImage(_ image: UIImage, indexPath: IndexPath) {
        if indexPath == self.indexPath {
            loadingIndicatorView.stopAnimating()
            thumbnailImageView.image = image
        }
    }

    override func prepareForReuse() {
        loadingIndicatorView.startAnimating()
        thumbnailImageView.image = nil
        stockLabel.textColor = .gray
        discountedPriceLabel.isHidden = true
    }
}
