//
//  WeatherCell.swift
//  Collaboration
//
//  Created by Akaki Titberidze on 18.05.24.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    // MARK: - Variables
    
    static let reuseIdentifier = "WeatherCell"
    
    // MARK: UI Components
    
    private let timeLabel = UILabel()
    private let imageView = UIImageView()
    private let temperatureLabel = UILabel()
    
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
        setupTimeLabel()
        setupImageView()
        setupTemperatureLabel()
    }
    
    private func setupTimeLabel() {
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: 16)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = .systemGray
        addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4)
        ])
    }
    
    private func setupTemperatureLabel() {
        temperatureLabel.textAlignment = .center
        temperatureLabel.font = UIFont.systemFont(ofSize: 20)
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    // MARK: - Helper Functions
    
    func configure(with image: String, temperature: String, time: String) {
        timeLabel.text = time
        temperatureLabel.text = temperature
        if let imageURL = URL(string: image) {
            imageView.loadImage(from: imageURL)
            if image != "" {
                imageView.backgroundColor = .systemGray3
            }
        }
    }
}

