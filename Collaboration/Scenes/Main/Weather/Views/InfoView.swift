//
//  InfoView.swift
//  Collaboration
//
//  Created by Akaki Titberidze on 18.05.24.
//

import UIKit

class InfoView: UIView {
        
    // MARK: - UI Components
    
    private let imageView = UIImageView()
    private let topLabel = UILabel()
    private let middleLabel = UILabel()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    // MARK: - UI Setup
    
    private func setupLayout() {
        setupUIView()
        setupImageView()
        setupTopLabel()
        setupMiddleLabel()
    }
    
    private func setupUIView() {
        backgroundColor = .systemBackground
//        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray2.cgColor
        layer.cornerRadius = 6
        layer.masksToBounds = true
        heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemGray2
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageView.widthAnchor.constraint(equalToConstant: 16),
            imageView.heightAnchor.constraint(equalToConstant: 16),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        ])
    }
    
    private func setupTopLabel() {
        topLabel.textAlignment = .left
        topLabel.font = UIFont.systemFont(ofSize: 16)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.textColor = .systemGray2
        addSubview(topLabel)
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            topLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            topLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
    
    private func setupMiddleLabel() {
        middleLabel.textAlignment = .left
        middleLabel.font = UIFont.systemFont(ofSize: 28)
        middleLabel.numberOfLines = 0
        middleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(middleLabel)
        
        NSLayoutConstraint.activate([
            middleLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 16),
            middleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            middleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            middleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Helper Functions
    
    func configure(image: UIImage?, topText: String, middleText: String) {
        imageView.image = image
        topLabel.text = topText
        middleLabel.text = middleText
    }
    
}
