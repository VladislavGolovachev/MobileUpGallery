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
        
        return russianDate(from: date)
    }
    
    func goToPreviousScreen() {
        router?.popToPreviousViewController()
    }
}

//MARK: Private Functions
extension PhotoPresenter {
    private var russianMonthDictionary: [String: String] {
        [
            "January": "января",
            "February": "февраля",
            "March": "марта",
            "April": "апреля",
            "May": "мая",
            "June": "июня",
            "July": "июля",
            "August": "августа",
            "September": "сентября",
            "October": "октября",
            "November": "ноября",
            "December": "декабря"
        ]
    }
    
    private func russianDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none

        let formattedString = formatter.string(from: date)
        let components = formattedString.components(separatedBy: " ")
        let (day, month, year) = (components[0], components[1], components[2])
        
        let russianMonth = russianMonthDictionary[month] ?? ""
        return "\(day) \(russianMonth) \(year)"
    }
}
