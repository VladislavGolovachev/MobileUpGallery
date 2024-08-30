//
//  PhotoViewController.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import UIKit

final class PhotoViewController: UIViewController {
    var presenter: PhotoViewPresenterProtocol?
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        imageView.image = presenter?.photo()
        imageView.contentMode = .scaleAspectFit
        
        customizeNavigationBar()
        view.addSubview(imageView)
        setupConstraints()
    }
}

//MARK: Private Functions
extension PhotoViewController {
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func customizeNavigationBar() {
        navigationItem.title = presenter?.date()

        let config = UIImage.SymbolConfiguration(weight: .semibold)
        let backButtonImage = UIImage(systemName: "chevron.left", withConfiguration: config)
        let shareButtonImage = UIImage(systemName: "square.and.arrow.up", withConfiguration: config)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: shareButtonImage,
                                                            style: .done,
                                                            target: self, 
                                                            action: #selector(shareButtonAction(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImage,
                                                            style: .done,
                                                            target: self,
                                                           action: #selector(backButtonAction(_:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
}

//MARK: Actions
extension PhotoViewController {
    @objc func shareButtonAction(_ sender: UIBarButtonItem) {
        guard let image = imageView.image else {return}
        let shareSheet = UIActivityViewController(activityItems: [image],
                                                  applicationActivities: nil)
        shareSheet.excludedActivityTypes = [.print, .assignToContact]
        shareSheet.completionWithItemsHandler = { [weak self] activityType, success, _, error in
            if success && activityType == .saveToCameraRoll {
                self?.showAlert(title: "Сообщение", message: "Фото успешно сохранено")
            } else 
            if let error {
                self?.showAlert(title: "Возникла ошибка", message: "Не удалось сохранить изображение")
            }
        }
        
        present(shareSheet, animated: true)
    }
    
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        presenter?.goToPreviousScreen()
    }
}

//MARK: Private Functions
extension PhotoViewController {
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: .default))
        self.present(alert, animated: true)
    }
}

//MARK: PhotoViewProtocol
extension PhotoViewController: PhotoViewProtocol {
    
}
