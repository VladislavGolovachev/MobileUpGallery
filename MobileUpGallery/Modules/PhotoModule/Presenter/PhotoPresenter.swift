//
//  PhotoPresenter.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 21.08.2024.
//

import UIKit

protocol PhotoViewProtocol: AnyObject {
    
}

protocol PhotoViewPresenterProtocol: AnyObject {
    init(view: PhotoViewProtocol, router: RouterProtocol, photoID: String)
    func goToPreviousScreen()
    func photo() -> UIImage
    func date() -> String
}

final class PhotoPresenter: PhotoViewPresenterProtocol {
    weak var view: PhotoViewProtocol?
    var router: RouterProtocol?
    let photoID: String
    
    init(view: PhotoViewProtocol, router: RouterProtocol, photoID: String) {
        self.view = view
        self.router = router
        self.photoID = photoID
    }
    
    func photo() -> UIImage {
        let photoInstance = DataManager.shared.photo(forKey: photoID)
        guard let data = photoInstance?.data,
              let image = UIImage(data: data) else {
            return UIImage()
        }
        return image
    }
    
    func date() -> String {
        let photoInstance = DataManager.shared.photo(forKey: photoID)
        guard let date = photoInstance?.creationDate else {return ""}
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none

        let formattedString = formatter.string(from: date)
        let dateString = formattedString.prefix(formattedString.count - 2)
        
        return "\(dateString)"
    }
    
    func goToPreviousScreen() {
        router?.popToPreviousViewController()
    }
}
