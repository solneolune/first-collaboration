//
//  WindView.swift
//  Collaboration
//
//  Created by Akaki Titberidze on 18.05.24.
//

import UIKit

class WindView: UIView {
    
    // MARK: - UI Components
    
    private let imageView = UIImageView()
    private let topLabel = UILabel()
    private let weatherVaneContainer = UIView()
    private let northLabel = UILabel()
    private let eastLabel = UILabel()
    private let southLabel = UILabel()
    private let westLabel = UILabel()
    private let arrowView = ArrowView()
    private let weatherVaneCenterView = UIView()
    private let weatherVaneLabel = UILabel()
    private let weatherWindGustView = UIView()
    private let weatherWindLabel = UILabel()
    private let weatherGustLabel = UILabel()
    
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
        setupWeatherVaneContainer()
        setupCompassLabels()
        setupArrowView()
        setupWeatherVaneCenterView()
        setupWeatherWindGustView()
    }
    
    private func setupUIView() {
        backgroundColor = .systemBackground
//        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray2.cgColor
        layer.cornerRadius = 6
        layer.masksToBounds = true
        heightAnchor.constraint(equalToConstant: 164).isActive = true
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
    
    private func setupWeatherVaneContainer() {
        weatherVaneContainer.layer.borderWidth = 1
        weatherVaneContainer.layer.borderColor = UIColor.systemGray2.cgColor
        weatherVaneContainer.layer.cornerRadius = 60
        
        weatherVaneContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(weatherVaneContainer)
        
        NSLayoutConstraint.activate([
            weatherVaneContainer.heightAnchor.constraint(equalToConstant: 120),
            weatherVaneContainer.widthAnchor.constraint(equalToConstant: 120),
            weatherVaneContainer.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 4),
            weatherVaneContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func setupCompassLabels() {
        configureLabel(northLabel, text: "N")
        configureLabel(eastLabel, text: "E")
        configureLabel(southLabel, text: "S")
        configureLabel(westLabel, text: "W")
        
        NSLayoutConstraint.activate([
            northLabel.centerXAnchor.constraint(equalTo: weatherVaneContainer.centerXAnchor),
            northLabel.topAnchor.constraint(equalTo: weatherVaneContainer.topAnchor, constant: 2),
            
            eastLabel.centerYAnchor.constraint(equalTo: weatherVaneContainer.centerYAnchor),
            eastLabel.trailingAnchor.constraint(equalTo: weatherVaneContainer.trailingAnchor, constant: -4),
            
            southLabel.centerXAnchor.constraint(equalTo: weatherVaneContainer.centerXAnchor),
            southLabel.bottomAnchor.constraint(equalTo: weatherVaneContainer.bottomAnchor, constant: -2),
            
            westLabel.centerYAnchor.constraint(equalTo: weatherVaneContainer.centerYAnchor),
            westLabel.leadingAnchor.constraint(equalTo: weatherVaneContainer.leadingAnchor, constant: 4)
        ])
    }
    
    private func setupArrowView() {
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        weatherVaneContainer.addSubview(arrowView)
        
        NSLayoutConstraint.activate([
            arrowView.centerXAnchor.constraint(equalTo: weatherVaneContainer.centerXAnchor),
            arrowView.centerYAnchor.constraint(equalTo: weatherVaneContainer.centerYAnchor),
            arrowView.widthAnchor.constraint(equalTo: weatherVaneContainer.widthAnchor),
            arrowView.heightAnchor.constraint(equalTo: weatherVaneContainer.heightAnchor)
        ])
        
        arrowView.rotate(to: 120)
    }
    
    private func setupWeatherVaneCenterView() {
        weatherVaneCenterView.translatesAutoresizingMaskIntoConstraints = false
        weatherVaneContainer.addSubview(weatherVaneCenterView)
        weatherVaneCenterView.backgroundColor = .systemBackground
        weatherVaneCenterView.layer.borderColor = UIColor.systemGray6.cgColor
        weatherVaneCenterView.layer.borderWidth = 1
        weatherVaneCenterView.clipsToBounds = true
        weatherVaneCenterView.layer.cornerRadius = 27
        
        weatherVaneLabel.font = UIFont.systemFont(ofSize: 20)
        weatherVaneLabel.textColor = .systemGray
        weatherVaneLabel.textAlignment = .center
        weatherVaneLabel.translatesAutoresizingMaskIntoConstraints = false
        
        weatherVaneCenterView.addSubview(weatherVaneLabel)
        
        NSLayoutConstraint.activate([
            weatherVaneCenterView.centerXAnchor.constraint(equalTo: weatherVaneContainer.centerXAnchor),
            weatherVaneCenterView.centerYAnchor.constraint(equalTo: weatherVaneContainer.centerYAnchor),
            weatherVaneCenterView.heightAnchor.constraint(equalToConstant: 54),
            weatherVaneCenterView.widthAnchor.constraint(equalToConstant: 54),
            
            weatherVaneLabel.centerXAnchor.constraint(equalTo: weatherVaneCenterView.centerXAnchor),
            weatherVaneLabel.centerYAnchor.constraint(equalTo: weatherVaneCenterView.centerYAnchor),
        ])
    }
    
    private func setupWeatherWindGustView() {
        let dividerLine = UIView()
        dividerLine.backgroundColor = .systemGray3

        let windInfoLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .systemGray2
            label.text = "KM/H - Wind"
            return label
        }()
        
        let gustInfoLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .systemGray2
            label.text = "KM/H - Gusts"
            return label
        }()

        weatherWindLabel.font = UIFont.systemFont(ofSize: 28)
        weatherGustLabel.font = UIFont.systemFont(ofSize: 28)
        
        weatherWindGustView.translatesAutoresizingMaskIntoConstraints = false
        weatherWindLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherGustLabel.translatesAutoresizingMaskIntoConstraints = false
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        windInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        gustInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(weatherWindGustView)
        weatherWindGustView.addSubview(weatherWindLabel)
        weatherWindGustView.addSubview(weatherGustLabel)
        weatherWindGustView.addSubview(dividerLine)
        weatherWindGustView.addSubview(windInfoLabel)
        weatherWindGustView.addSubview(gustInfoLabel)
        
        NSLayoutConstraint.activate([
            weatherWindGustView.heightAnchor.constraint(equalToConstant: 70),
            weatherWindGustView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            weatherWindGustView.trailingAnchor.constraint(equalTo: weatherVaneContainer.leadingAnchor, constant: -8),
            weatherWindGustView.centerYAnchor.constraint(equalTo: weatherVaneContainer.centerYAnchor),

            weatherWindLabel.leadingAnchor.constraint(equalTo: weatherWindGustView.leadingAnchor),
            weatherWindLabel.topAnchor.constraint(equalTo: weatherWindGustView.topAnchor),
            
            weatherGustLabel.leadingAnchor.constraint(equalTo: weatherWindGustView.leadingAnchor),
            weatherGustLabel.bottomAnchor.constraint(equalTo: weatherWindGustView.bottomAnchor),
            
            dividerLine.centerYAnchor.constraint(equalTo: weatherWindGustView.centerYAnchor),
            dividerLine.heightAnchor.constraint(equalToConstant: 1),
            dividerLine.leadingAnchor.constraint(equalTo: weatherWindGustView.leadingAnchor),
            dividerLine.trailingAnchor.constraint(equalTo: weatherWindGustView.trailingAnchor),
            
            windInfoLabel.leadingAnchor.constraint(equalTo: weatherWindLabel.trailingAnchor, constant: 8),
            windInfoLabel.centerYAnchor.constraint(equalTo: weatherWindLabel.centerYAnchor),
            
            gustInfoLabel.leadingAnchor.constraint(equalTo: weatherGustLabel.trailingAnchor, constant: 8),
            gustInfoLabel.centerYAnchor.constraint(equalTo: weatherGustLabel.centerYAnchor),
        ])
        addSubview(weatherWindGustView)
    }
    
    // MARK: - Helper Functions
    
    func configure(image: UIImage?, topText: String, windDegree: Int, windDirection: String, windSpeed: String, gustSpeed: String) {
        imageView.image = image
        topLabel.text = topText
        weatherVaneLabel.text = windDirection
        weatherWindLabel.text = windSpeed
        weatherGustLabel.text = gustSpeed
        DispatchQueue.main.async {
            self.arrowView.rotate(to: CGFloat(windDegree))
        }
    }
    
    private func configureLabel(_ label: UILabel, text: String) {
        label.text = text
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        weatherVaneContainer.addSubview(label)
    }
    
}
