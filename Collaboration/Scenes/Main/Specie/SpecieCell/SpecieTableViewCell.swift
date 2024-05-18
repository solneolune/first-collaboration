//
//  SpecieTableViewCell.swift
//  Collaboration
//
//  Created by Data on 18.05.24.
//

import UIKit

class SpecieTableViewCell: UITableViewCell {
    // MARK: - Variable
    var learnMoreURL: URL?
    
    // MARK: - UI Components
    let nameOfSpecie: UILabel = {
        let name = UILabel()
        name.font = UIFont.boldSystemFont(ofSize: 20)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    let nameOfUploader: UILabel = {
        let name = UILabel()
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.textColor = .systemGray2
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    let pictureOfSpacie: UIImageView = {
        let picture = UIImageView()
        picture.contentMode = .scaleAspectFill
        picture.layer.cornerRadius = 10
        picture.clipsToBounds = true
        picture.translatesAutoresizingMaskIntoConstraints = false
        return picture
    }()
    
    let learnMoreButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "wikipediaLogo")
        button.setImage(image, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - UI Setup
    func addSubviews() {
        addSubview(nameOfSpecie)
        addSubview(nameOfUploader)
        addSubview(pictureOfSpacie)
        addSubview(learnMoreButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            pictureOfSpacie.centerYAnchor.constraint(equalTo: centerYAnchor),
            pictureOfSpacie.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            pictureOfSpacie.widthAnchor.constraint(equalToConstant: 80),
            pictureOfSpacie.heightAnchor.constraint(equalToConstant: 80),
            
            nameOfSpecie.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameOfSpecie.leadingAnchor.constraint(equalTo: pictureOfSpacie.trailingAnchor, constant: 10),
            nameOfSpecie.trailingAnchor.constraint(equalTo: learnMoreButton.leadingAnchor, constant: -5),
            
            nameOfUploader.topAnchor.constraint(equalTo: nameOfSpecie.bottomAnchor, constant: 10),
            nameOfUploader.leadingAnchor.constraint(equalTo: pictureOfSpacie.trailingAnchor, constant: 10),
            nameOfUploader.trailingAnchor.constraint(equalTo: learnMoreButton.leadingAnchor, constant: -10),
            
            learnMoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            learnMoreButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            learnMoreButton.heightAnchor.constraint(equalToConstant: 30),
            learnMoreButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        learnMoreButton.addAction(UIAction(handler: { _ in
            self.learnMoreButtonTapped()
        }), for: .touchUpInside)
    }
    
    // MARK: - Configure
    
    func configure(specieName: String, nameUploader: String, image: String, wikipediaURL: String?) {
        nameOfSpecie.text = specieName
        nameOfUploader.text = nameUploader
        
        guard let imageURL = URL(string: image) else {
            pictureOfSpacie.image = nil
            return
        }
        pictureOfSpacie.loadImage(from: imageURL)
        
        if let urlString = wikipediaURL, let url = URL(string: urlString) {
            learnMoreURL = url
            learnMoreButton.isHidden = false
        } else {
            learnMoreButton.isHidden = true
        }
    }
    func learnMoreButtonTapped() {
        guard let url = learnMoreURL else { return }
        print(url)
        UIApplication.shared.open(url)
        
    }
}
