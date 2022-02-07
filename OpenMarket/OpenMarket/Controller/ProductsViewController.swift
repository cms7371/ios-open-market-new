//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProductsViewController: UIViewController {

    var displayStyleControlView: UISegmentedControl!
    var collectionView: UICollectionView!

    var isList = true
    var products: [Product] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    var dataSourceSnapshot: NSDiffableDataSourceSnapshot<Section, Product>!

    enum Section {
        case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDisplayStyleControlView()
        configureNavigationItem()
        configureHierarchy()
        configureDataSource()
    }
}

extension ProductsViewController {
    func configureDisplayStyleControlView() {
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
                                            #selector(changedValueDisplayStyleControlView(_:)), for: .valueChanged)
    }

    @objc private func changedValueDisplayStyleControlView(_ sender: Any) {
        isList = displayStyleControlView.selectedSegmentIndex == 0
        collectionView.reloadData()
    }

    func configureNavigationItem() {
        navigationItem.titleView = displayStyleControlView
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "plus"),
                                                            style: .plain, target: self, action: nil)
    }

    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }

    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, _ in
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
        dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        dataSourceSnapshot.appendSections([.main])
        updateProducts()
    }

    func updateProducts() {
        MarketAPI.getProducts(pageNumber: 1, itemCount: 100) { productsData in
            do {
                let productPage: ProductPage = try JSONCoder.shared.decode(from: productsData)
                DispatchQueue.main.async {
                    self.products.append(contentsOf: productPage.products)
                    self.dataSourceSnapshot.appendItems(productPage.products)
                    self.dataSource.apply(self.dataSourceSnapshot)
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
