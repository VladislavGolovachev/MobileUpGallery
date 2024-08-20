//
//  VideoViewController.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import UIKit

final class VideoViewController: UIViewController {

    var presenter: VideoViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension VideoViewController: VideoViewProtocol {
    
}
