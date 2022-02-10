//
//  ProductEditViewControllerBase.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/08.
//

import UIKit

class ProductEditViewControllerBase: UIViewController {

    private var numberTextFieldDelegate = NumberTextFieldDelegate()

    let imageStackView: UIStackView = UIStackView()
    private let imageScrollView: UIScrollView = UIScrollView()
    let nameField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "상품명"
        return field
    }()

    let priceField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "상품가격"
        field.keyboardType = .numberPad
        return field
    }()

    let currencySegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: Product.Currency.allCases.map { $0.rawValue })
        control.selectedSegmentIndex = 0
        return control
    }()

    let priceCurrencyStackView = UIStackView()
    let bargainPriceField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "할인금액"
        field.keyboardType = .numberPad
        return field
    }()

    let stockField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "재고수량"
        field.keyboardType = .numberPad
        return field
    }()

    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = String(repeating: "example\n", count: 100)
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        return textView
    }()

    private let mainStackView: UIStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureNavigationItems()
        configureContentRelationalProperties()
        configureHierarchy()
        configureConstraints()
    }

    func configureNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain,
                                                           target: self, action: #selector(touchUpCancelButton(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: nil)
    }

    func configureContentRelationalProperties() {
        priceField.delegate = numberTextFieldDelegate
        bargainPriceField.delegate = numberTextFieldDelegate
        stockField.delegate = numberTextFieldDelegate
    }

    func configureHierarchy() {
        imageStackView.axis = .horizontal
        imageStackView.alignment = .fill
        imageStackView.distribution = .equalSpacing
        imageStackView.spacing = 8

        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.addSubview(imageStackView)

        [priceField, currencySegmentedControl].forEach { priceCurrencyStackView.addArrangedSubview($0) }
        priceCurrencyStackView.axis = .horizontal
        priceCurrencyStackView.distribution = .fill
        priceCurrencyStackView.spacing = 8
        priceCurrencyStackView.alignment = .center
        priceField.setContentHuggingPriority(.defaultLow, for: .horizontal)

        [imageScrollView, nameField, priceCurrencyStackView, bargainPriceField, stockField, descriptionTextView]
            .forEach { mainStackView.addArrangedSubview($0) }
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.spacing = 8
        mainStackView.alignment = .fill
        descriptionTextView.setContentHuggingPriority(.defaultLow, for: .vertical)

        view.addSubview(mainStackView)
    }

    func configureConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.topAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.trailingAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.bottomAnchor),
            imageStackView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            imageScrollView.heightAnchor.constraint(equalTo: imageStackView.heightAnchor)
        ])
    }

    @objc private func touchUpCancelButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

class NumberTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let filteredNumberText: String = string.filter { $0.isNumber }
        if let replaceStart = textField.position(from: textField.beginningOfDocument, offset: range.location),
           let replaceEnd = textField.position(from: replaceStart, offset: range.length),
           let replaceRange = textField.textRange(from: replaceStart, to: replaceEnd) {
            textField.replace(replaceRange, withText: filteredNumberText)
        }
        return false
    }
}

#if DEBUG
import SwiftUI

struct ProductEditViewControllerBase_Previews: PreviewProvider {
    static var previews: some View {
        Container().previewDevice(PreviewDevice(rawValue: "iPhone 11"))
    }
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return UINavigationController(rootViewController: ProductEditViewControllerBase())
        }
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
}
#endif
