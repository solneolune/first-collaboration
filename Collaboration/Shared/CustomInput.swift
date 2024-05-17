//
//  CustomInput.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.
//

import UIKit

class CustomInputView: UIView {
    
    private let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func styleTextField(_ textfield: UITextField, placeholder: String) {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .font: UIFont(name: "FiraGO-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        ])
        textField.textColor = .label
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 9
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    public var text: String? {
        return textField.text
    }
}

