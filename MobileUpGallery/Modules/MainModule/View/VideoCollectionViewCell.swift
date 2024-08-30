//
//  VIdeoCollectionViewCell.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 22.08.2024.
//

import UIKit

final class VideoCollectionViewCell: PhotoCollectionViewCell {
    lazy var label: UILabel = {
        let label = PaddingLabel(topInset: 4, leftInset: 12, bottomInset: 4, rightInset: 12)
        label.backgroundColor = UIColor(white: 1, alpha: 0.5)
        label.textColor = .black
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 16
        label.numberOfLines = 0
        label.text = "Кейс Самоката для P1. Как мы сделали концепцию программы лояльности для фудтеха и победили (опять!)"
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: bottomAnchor, 
                                          constant: Constants.Constraints.Label.bottomConstant),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, 
                                            constant: Constants.Constraints.Label.trailingConstant),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, 
                                           constant: Constants.Constraints.Label.leadingConstant),
            label.topAnchor.constraint(greaterThanOrEqualTo: topAnchor)
        ])
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}

//MARK: Constants
extension VideoCollectionViewCell {
    enum Constants {
        enum Constraints {
            enum Label {
                static let bottomConstant = -16.0
                static let trailingConstant = -16.0
                static let leadingConstant = 131.0
            }
        }
    }
}
