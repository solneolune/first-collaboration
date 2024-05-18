//
//  CustomCardCell.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.
//

import UIKit

class CustomCardCell: UICollectionViewCell {
    static let identifier = "CustomCardCell"
    let iconImg = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with card: CustomCard) {
        iconImg.image = UIImage(systemName: card.icon.systemName)
        titleLabel.text = card.title
        descriptionLabel.text = card.description
    }
    
    // MARK: - Setup and Styling
    func setupUI() {
        styleCard()
        styleIcon()
        styleTitle()
        styleDescription()
    }
    
    func styleCard() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
    }
    
    func styleIcon() {
        iconImg.contentMode = .scaleAspectFit
        iconImg.clipsToBounds = true
        iconImg.tintColor = UIColor.systemYellow
        iconImg.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImg)
        NSLayoutConstraint.activate([
            iconImg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            iconImg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconImg.widthAnchor.constraint(equalToConstant: 50),
            iconImg.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func styleTitle() {
        titleLabel.font = UIFont(name: "FiraGO-SemiBold", size: 16)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: iconImg.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    func styleDescription() {
        descriptionLabel.font = UIFont(name: "FiraGO-Medium", size: 10)
        descriptionLabel.textColor = .label
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
