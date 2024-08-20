//
//  MainViewController.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import UIKit

final class MainViewController: UIViewController {

    var presenter: MainViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MainViewController: MainViewProtocol {
    
}
