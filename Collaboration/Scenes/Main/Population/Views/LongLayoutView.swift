//
//  LongLayoutView.swift
//  Collaboration
//
//  Created by Elene Donadze on 5/18/24.
//

import UIKit

class LongLayoutView: UIView {
        
    // MARK: - UI Components
    
    private let leftLabel = UILabel()
    private let rightLabel = UILabel()
    
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
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        setupTopLabel()
        setupMiddleLabel()
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    private func setupTopLabel() {
        leftLabel.textAlignment = .left
        leftLabel.font = UIFont.systemFont(ofSize: 18)
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftLabel)
        
        NSLayoutConstraint.activate([
            leftLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
           
        ])
    }
    
    private func setupMiddleLabel() {
        rightLabel.textAlignment = .right
        rightLabel.font = UIFont.systemFont(ofSize: 18)
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightLabel)
        
        NSLayoutConstraint.activate([
            rightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rightLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    
    // MARK: - Helper Functions
    
    func configure(leftText: String, rightText: String) {
        leftLabel.text = leftText
        rightLabel.text = rightText

    }
}
