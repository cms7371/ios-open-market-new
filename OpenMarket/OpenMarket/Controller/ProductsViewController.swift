//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProductsViewController: UIViewController {

    var displayStyleControlView: UISegmentedControl!

    var isGrid = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDisplayStyleView()
        configureNavigationItem()
    }
}

extension ProductsViewController {
    func configureDisplayStyleView() {
        displayStyleControlView = UISegmentedControl(items: ["LIST", "GRID"])
        displayStyleControlView.selectedSegmentTintColor = .systemBlue
        displayStyleControlView.selectedSegmentIndex = 0
        displayStyleControlView.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        displayStyleControlView.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        displayStyleControlView.setWidth(80, forSegmentAt: 0)
        displayStyleControlView.setWidth(80, forSegmentAt: 1)
        displayStyleControlView.layer.borderWidth = 1.5
        displayStyleControlView.layer.borderColor = UIColor.systemBlue.cgColor
        displayStyleControlView.addTarget(self, action:
                                            #selector(touchUpDisplayStyleControlView(_:)), for: .valueChanged)
    }

    @objc private func touchUpDisplayStyleControlView(_ sender: Any) {
        isGrid = displayStyleControlView.selectedSegmentIndex == 1
    }

    func configureNavigationItem() {
        navigationItem.titleView = displayStyleControlView

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "plus"),
                                                            style: .plain, target: self, action: nil)
    }
}

extension ProductsViewController {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let column = self.isGrid ? 2 : 1
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            // item.contentInsets

            let groupHeight = self.isGrid ?
                    NSCollectionLayoutDimension.absolute(100.0) : NSCollectionLayoutDimension.absolute(250.0)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: column)

            let section = NSCollectionLayoutSection(group: group)
            // section.contentInsets
            return section
        }
    }
}

#if DEBUG
import SwiftUI

struct ProductViewController_Previews: PreviewProvider {
    static var previews: some View {
        Container().previewDevice(PreviewDevice(rawValue: "iPhone 11"))
    }
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return UINavigationController(rootViewController: ProductsViewController())
        }
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
}
#endif
