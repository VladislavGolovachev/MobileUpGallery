//
//  PhotoViewController.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import UIKit

final class PhotoViewController: UIViewController {

    var presenter: PhotoViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PhotoViewController: PhotoViewProtocol {
    
}
