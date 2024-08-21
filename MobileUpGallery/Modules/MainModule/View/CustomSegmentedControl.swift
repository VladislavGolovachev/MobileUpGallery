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
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.04).cgColor
        setShadow(to: button)
        
        return button
    }()
    private lazy var secondButton: UIButton = {
        let button = UIButton(type: .custom, primaryAction: nil)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.04).cgColor
        
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
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2)
        ])
    }
    
    private func setShadow(to button: UIButton) {
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)

        button.layer.masksToBounds = false
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.12
        button.layer.shadowRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
    }
    
    private func resetShadow(to button: UIButton) {
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
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
