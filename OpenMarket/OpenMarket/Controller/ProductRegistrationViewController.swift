//
//  ProductPostViewController.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/09.
//

import UIKit
import PhotosUI

class ProductRegistrationViewController: ProductEditViewControllerBase, UINavigationControllerDelegate {

    private let addImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray5
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()

    override func configureNavigationItems() {
        super.configureNavigationItems()
        navigationItem.title = "상품등록"
    }

    override func configureContentRelationalProperties() {
        super.configureContentRelationalProperties()
        addImageButton.addTarget(self, action: #selector(self.touchUpAddImageButton(_:)), for: .touchUpInside)
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        imageStackView.addArrangedSubview(addImageButton)
    }

    override func configureConstraints() {
        super.configureConstraints()
        addImageButton.widthAnchor.constraint(equalTo: addImageButton.heightAnchor).isActive = true
    }

    @objc func touchUpAddImageButton(_ sender: Any) {
        let imageSelectionAlert = UIAlertController(title: "사진 추가", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "카메라", style: .default, handler: presentCameraPickerAction)
        let albumAction = UIAlertAction(title: "앨범", style: .default, handler: presentAlbumPickerAction)
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        [cameraAction, albumAction, cancelAction].forEach { imageSelectionAlert.addAction($0) }
        present(imageSelectionAlert, animated: true, completion: nil)
    }

    func presentCameraPickerAction(alertAction: UIAlertAction) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            let unavailableAlert = UIAlertController(title: "카메라 사용이 불가능한 기기입니다", message: nil, preferredStyle: .alert)
            present(unavailableAlert, animated: true) { [weak unavailableAlert] in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) { [weak unavailableAlert] in
                    unavailableAlert?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    func presentAlbumPickerAction(alertAction: UIAlertAction) {
        var imagePickerConfiguration = PHPickerConfiguration()
        imagePickerConfiguration.filter = .images
        imagePickerConfiguration.selectionLimit = 5
        let imagePicker = PHPickerViewController(configuration: imagePickerConfiguration)
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension ProductRegistrationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageStackView.insertArrangedSubview(imageView, at: 0)
    }
}

extension ProductRegistrationViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        return
    }
}
