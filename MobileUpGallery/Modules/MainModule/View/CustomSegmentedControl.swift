//
//  CustomSegmentedControl.swift
//  MobileUpGallery
//
//  Created by Владислав Головачев on 22.08.2024.
//

import UIKit

protocol SegmentedControlFeatures {
    var firstItem: UIButton {get}
    var secondItem: UIButton {get}
    var selectedSegment: Int {get}
    func selectSegment(at id: Int)
}

final class CustomSegmentedControl: UIView {
    private var _selectedSegment = 0
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(firstButton)
        stackView.addArrangedSubview(secondButton)
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 8
        
        return stackView
    }()
    private lazy var firstButton: UIButton = {
        let button = UIButton(type: .custom, primaryAction: nil)
        button.backgroundColor = Constants.Color.background
        button.setTitleColor(Constants.Color.text, for: .normal)
        button.layer.borderColor = Constants.Color.border
        setShadow(to: button)
        
        return button
    }()
    private lazy var secondButton: UIButton = {
        let button = UIButton(type: .custom, primaryAction: nil)
        button.backgroundColor = Constants.Color.background
        button.setTitleColor(Constants.Color.text, for: .normal)
        button.titleLabel?.font = Constants.Font.notSelected
        button.layer.borderColor = Constants.Color.border
        
        return button
    }()
    
    convenience init(firstTitle: String, secondTitle: String) {
        self.init()
        
        firstButton.setTitle(firstTitle, for: .normal)
        secondButton.setTitle(secondTitle, for: .normal)
        
        self.addSubview(stackView)
        setupConstraints()
    }
}

//MARK: Private functions
extension CustomSegmentedControl {
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, 
                                               constant: Constants.padding),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                constant: -Constants.padding),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, 
                                              constant: -Constants.padding),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, 
                                           constant: Constants.padding)
        ])
    }
    
    private func setShadow(to button: UIButton) {
        button.titleLabel?.font = Constants.Font.selected

        button.layer.masksToBounds = false
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 0.5
        button.layer.shadowOffset = Constants.Shadow.offset
        button.layer.shadowOpacity = Constants.Shadow.opacity
        button.layer.shadowRadius = Constants.Shadow.radius
        button.layer.shadowColor = Constants.Color.shadow
    }
    
    private func resetShadow(to button: UIButton) {
        button.titleLabel?.font = Constants.Font.notSelected
        button.layer.borderWidth = 0
        button.layer.shadowOpacity = 0
    }
}

//MARK: SegmentedControlFeatures
extension CustomSegmentedControl: SegmentedControlFeatures {
    var firstItem: UIButton {
        return firstButton
    }
    
    var secondItem: UIButton {
        return secondButton
    }
    
    var selectedSegment: Int {
        get {
            return _selectedSegment
        }
    }
    
    func selectSegment(at id: Int) {
        _selectedSegment = id
        if id == 0 {
            UIView.animate(withDuration: 0.3) {
                self.resetShadow(to: self.secondButton)
                self.setShadow(to: self.firstButton)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.resetShadow(to: self.firstButton)
                self.setShadow(to: self.secondButton)
            }
        }
    }
}

//MARK: Constants
extension CustomSegmentedControl {
    enum Constants {
        static let padding = 2.0
        enum Font {
            static let selected = UIFont.systemFont(ofSize: 13, weight: .semibold)
            static let notSelected = UIFont.systemFont(ofSize: 13, weight: .medium)
        }
        enum Color {
            static let border = UIColor(red: 0, green: 0, blue: 0, alpha: 0.04).cgColor
            static let background = UIColor.white
            static let text = UIColor.black
            static let shadow = UIColor.black.cgColor
        }
        enum Shadow {
            static let offset = CGSize(width: 0, height: 3)
            static let opacity: Float = 0.12
            static let radius = 8.0
        }
    }
    
}
