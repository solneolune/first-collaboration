//
//  TitleView.swift
//  Collaboration
//
//  Created by Akaki Titberidze on 18.05.24.
//

import UIKit

class TitleView: UIView {
        
    // MARK: - UI Components
    
    private let topLabel = UILabel()
    private let middleLabel = UILabel()
    private let bottomView = UIStackView()
    private let bottomLabel = UILabel()
    private let imageView = UIImageView()
    
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
        heightAnchor.constraint(equalToConstant: 140).isActive = true
        setupTopLabel()
        setupMiddleLabel()
        setupBottomView()
        
    }
    
    private func setupTopLabel() {
        topLabel.textAlignment = .center
        topLabel.font = UIFont.systemFont(ofSize: 22)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topLabel)
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            topLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            topLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setupMiddleLabel() {
        middleLabel.textAlignment = .center
        middleLabel.font = UIFont.systemFont(ofSize: 44)
        middleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(middleLabel)
        
        NSLayoutConstraint.activate([
            middleLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 4),
            middleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            middleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setupBottomView() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.axis = .horizontal
        bottomView.distribution = .equalSpacing
            
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true

        bottomLabel.textAlignment = .center
        bottomLabel.font = UIFont.systemFont(ofSize: 16)
        bottomLabel.textColor = .systemGray2
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(bottomView)
        bottomView.addArrangedSubview(bottomLabel)
        bottomView.addArrangedSubview(imageView)
        
        NSLayoutConstraint.activate([
            bottomView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomView.topAnchor.constraint(equalTo: middleLabel.bottomAnchor, constant: 8),
            bottomView.widthAnchor.constraint(equalToConstant: 100),
            
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    // MARK: - Helper Functions
    
    func configure(image: String, topText: String, middleText: String, bottomText: String) {
        topLabel.text = topText
        middleLabel.text = middleText
        bottomLabel.text = bottomText
        
        if let imageURL = URL(string: image) {
            imageView.loadImage(from: imageURL)
            if image != "" {
                imageView.backgroundColor = .systemGray3
            }
        }
    }
}

