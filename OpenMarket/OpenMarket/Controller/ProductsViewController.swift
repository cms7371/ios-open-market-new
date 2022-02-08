//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {

    var isList = true
    var products: [Product] = []

    var displayStyleControlView: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setWidth(80, forSegmentAt: 0)
        segmentedControl.setWidth(80, forSegmentAt: 1)
        segmentedControl.layer.borderWidth = 1.5
        segmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        return segmentedControl
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
    }()

    lazy var collectionViewLayout = UICollectionViewCompositionalLayout { _, _ in
        let column = self.isList ? 1 : 2
        let groupHeight = self.isList ?
            NSCollectionLayoutDimension.absolute(80) :
            NSCollectionLayoutDimension.absolute(250)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: column)
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        if !self.isList {
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        }
        return section
    }

    enum CollectionViewSection {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<CollectionViewSection, Product>?
    var dataSourceSnapshot: NSDiffableDataSourceSnapshot<CollectionViewSection, Product> = {
        var snapshot = NSDiffableDataSourceSnapshot<CollectionViewSection, Product>()
        snapshot.appendSections([.main])
        return snapshot
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureHierarchy()
        configureDataSource()
    }

    func configureNavigationItem() {
        navigationItem.titleView = displayStyleControlView
        displayStyleControlView.addTarget(self, action: #selector(changedValueDisplayStyleControlView(_:)),
                                          for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "plus"),
                                                            style: .plain, target: self, action: nil)
    }

    func configureHierarchy() {
        view.addSubview(collectionView)
    }

    func configureDataSource() {
        let listCellRegistration = UICollectionView
            .CellRegistration<ProductListCell, Product> { cell, indexPath, product in
                cell.updateContent(product: product, indexPath: indexPath)
                cell.lazyUpdateThumbnail(fromURL: product.thumbnailURLString, indexPath: indexPath)
        }
        let gridCellRegistration = UICollectionView
            .CellRegistration<ProductGridCell, Product> { cell, indexPath, product in
                cell.updateContent(product: product, indexPath: indexPath)
                cell.lazyUpdateThumbnail(fromURL: product.thumbnailURLString, indexPath: indexPath)
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                        cellProvider: { collectionView, indexPath, product in
            return self.isList ?
            collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: product) :
            collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: product)
        })
        updateProducts()
    }

    @objc private func changedValueDisplayStyleControlView(_ sender: Any) {
        isList = displayStyleControlView.selectedSegmentIndex == 0
        collectionView.reloadData()
    }

    func updateProducts() {
        MarketAPI.getProducts(pageNumber: 1, itemCount: 100) { productsData in
            do {
                let productPage: ProductPage = try JSONCoder.shared.decode(from: productsData)
                DispatchQueue.main.async {
                    self.products.append(contentsOf: productPage.products)
                    self.dataSourceSnapshot.appendItems(productPage.products)
                    self.dataSource?.apply(self.dataSourceSnapshot)
                }
            } catch {
                fatalError("ProductsViewController: JSON parsing error")
            }
        }
    }
}

extension ProductCellBase {
    func lazyUpdateThumbnail(fromURL: String, indexPath: IndexPath) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let thumbnailURL = URL(string: fromURL) else {
                print("WARNING:ProductsViewController.lazyUpdateThumbnail, fail to initializing URL from url string")
                return
            }
            do {
                let thumbnailData = try Data(contentsOf: thumbnailURL, options: .alwaysMapped)
                let thumbnailImage = UIImage(data: thumbnailData)
                DispatchQueue.main.async {
                    self.setThumbnailImage(thumbnailImage!, indexPath: indexPath)
                }
            } catch {
                print("WARNING:ProductsViewController.lazyUpdateThumbnail, \(error.localizedDescription)")
            }
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
