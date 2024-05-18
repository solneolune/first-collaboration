//
//  WeatherViewController.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.
//
import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Variables
    var viewModel: WeatherViewModel
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleView = TitleView()
    private let countryTextField = UITextField()
    private let countrySearchButton = CustomButton(title: "Search", backgroundColor: .label, setTitleColor: .systemGray6)
    private let minMaxTempStackView = UIStackView()
    private let minTempView = InfoView()
    private let maxTempView = InfoView()
    private let windView = WindView()
    private let humidityFeelsLikeStackView = UIStackView()
    private let humidityView = InfoView()
    private let feelsLikeView = InfoView()
    private let pressureVisibilityStackView = UIStackView()
    private let pressureView = InfoView()
    private let visibilityView = InfoView()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupData()
        viewModel.viewLoaded()
    }
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    func setupLayout() {
        view.backgroundColor = .systemGray6
        setupScrollView()
        setupTitleView()
        setupCountryTextField()
        setupCountryButton()
        setupCollectionView()
        setupMinMaxTempStackView()
        setupWindView()
        setupHumidityFeelsLikeStackView()
        setupPressureVisibilityStackView()
    }
    
    private func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupTitleView() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.configure(image: viewModel.getWeatherIcon(), topText: "", middleText: "", bottomText: "")
        contentView.addSubview(titleView)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupCountryTextField() {
        countryTextField.borderStyle = .roundedRect
        countryTextField.placeholder = "Enter a city"
        countryTextField.returnKeyType = .go
        countryTextField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(countryTextField)
        
        NSLayoutConstraint.activate([
            countryTextField.heightAnchor.constraint(equalToConstant: 40),
            countryTextField.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            countryTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
    }
    
    private func setupCountryButton() {
        countrySearchButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(countrySearchButton)
                
        NSLayoutConstraint.activate([
            countrySearchButton.heightAnchor.constraint(equalToConstant: 40),
            countrySearchButton.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            countrySearchButton.leadingAnchor.constraint(equalTo: countryTextField.trailingAnchor, constant: 16),
            countrySearchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            countrySearchButton.widthAnchor.constraint(equalToConstant: 80),
        ])
        
        countrySearchButton.addAction(UIAction(handler: { _ in
            self.searchTriggered(countryName: self.countryTextField.text ?? "")
        }), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WeatherCell.self, forCellWithReuseIdentifier: WeatherCell.reuseIdentifier)
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: countryTextField.bottomAnchor, constant: 16),
            collectionView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    private func setupMinMaxTempStackView() {
        minMaxTempStackView.axis = .horizontal
        minMaxTempStackView.distribution = .fillEqually
        minMaxTempStackView.alignment = .fill
        minMaxTempStackView.spacing = 16
        
        minTempView.configure(image: UIImage(systemName: "thermometer.snowflake"), topText: "min Temperature", middleText: "\(viewModel.getMinTemp())°")
        maxTempView.configure(image: UIImage(systemName: "thermometer.sun.fill"), topText: "max Temperature", middleText: "\(viewModel.getMaxTemp())°")

        contentView.addSubview(minMaxTempStackView)
        minMaxTempStackView.addArrangedSubview(minTempView)
        minMaxTempStackView.addArrangedSubview(maxTempView)
        
        minMaxTempStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            minMaxTempStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            minMaxTempStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            minMaxTempStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16)
        ])
    }
    
    private func setupWindView() {
        windView.translatesAutoresizingMaskIntoConstraints = false
        windView.configure(
            image: UIImage(systemName: "wind"),
            topText: "Wind",
            windDegree: viewModel.getWindDegree(),
            windDirection: viewModel.getDirection(),
            windSpeed: "\(viewModel.getWindSpeed())",
            gustSpeed: "\(viewModel.getGustSpeed())"
        )
        contentView.addSubview(windView)
        NSLayoutConstraint.activate([
            windView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            windView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            windView.topAnchor.constraint(equalTo: minMaxTempStackView.bottomAnchor, constant: 16),
        ])
    }
    
    private func setupHumidityFeelsLikeStackView() {
        humidityFeelsLikeStackView.axis = .horizontal
        humidityFeelsLikeStackView.distribution = .fillEqually
        humidityFeelsLikeStackView.alignment = .fill
        humidityFeelsLikeStackView.spacing = 16
        
        feelsLikeView.configure(image: UIImage(systemName: "thermometer.medium"), topText: "Feels like", middleText: "\(viewModel.getFeelsLike())°")
        humidityView.configure(image: UIImage(systemName: "humidity"), topText: "Humidity", middleText: "\(viewModel.getHumidity())%")

        contentView.addSubview(humidityFeelsLikeStackView)
        humidityFeelsLikeStackView.addArrangedSubview(feelsLikeView)
        humidityFeelsLikeStackView.addArrangedSubview(humidityView)
        
        humidityFeelsLikeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            humidityFeelsLikeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            humidityFeelsLikeStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            humidityFeelsLikeStackView.topAnchor.constraint(equalTo: windView.bottomAnchor, constant: 16)
        ])
    }
    
    private func setupPressureVisibilityStackView() {
        pressureVisibilityStackView.axis = .horizontal
        pressureVisibilityStackView.distribution = .fillEqually
        pressureVisibilityStackView.alignment = .fill
        pressureVisibilityStackView.spacing = 16
        
        visibilityView.configure(image: UIImage(systemName: "eye.fill"), topText: "Visibility", middleText: "\(viewModel.getVisibility())KM")
        pressureView.configure(image: UIImage(systemName: "sensor.tag.radiowaves.forward"), topText: "Pressure", middleText: "\(viewModel.getPressure())hPa")
        
        contentView.addSubview(pressureVisibilityStackView)
        pressureVisibilityStackView.addArrangedSubview(visibilityView)
        pressureVisibilityStackView.addArrangedSubview(pressureView)
        
        pressureVisibilityStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pressureVisibilityStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pressureVisibilityStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            pressureVisibilityStackView.topAnchor.constraint(equalTo: humidityFeelsLikeStackView.bottomAnchor, constant: 16),
            pressureVisibilityStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Helper Functions
    func setupData() {
        countryTextField.delegate = self
        countryTextField.addAction(UIAction(handler: { _ in
            self.searchTriggered(countryName: self.countryTextField.text ?? "")
        }), for: .editingDidEndOnExit)
    }
    
    func searchTriggered(countryName: String) {
        viewModel.fetchCountryCoordinates(country: countryName)
    }

    private func updateUI() {
        titleView.configure(image: viewModel.getWeatherIcon(), topText: viewModel.getSelectedCountryName(), middleText: "\(viewModel.getWeatherTemperature())°", bottomText: viewModel.getWeatherDetail())
        minTempView.configure(image: UIImage(systemName: "thermometer.snowflake"), topText: "min Temperature", middleText: "\(viewModel.getMinTemp())°")
        maxTempView.configure(image: UIImage(systemName: "thermometer.sun.fill"), topText: "max Temperature", middleText: "\(viewModel.getMaxTemp())°")
        humidityView.configure(image: UIImage(systemName: "humidity"), topText: "Humidity", middleText: "\(viewModel.getHumidity())%")
        feelsLikeView.configure(image: UIImage(systemName: "thermometer.medium"), topText: "Feels like", middleText: "\(viewModel.getFeelsLike())°")
        pressureView.configure(image: UIImage(systemName: "sensor.tag.radiowaves.forward"), topText: "Pressure", middleText: "\(viewModel.getPressure())hPa")
        visibilityView.configure(image: UIImage(systemName: "eye.fill"), topText: "Visibility", middleText: "\(viewModel.getVisibility())KM")
        windView.configure(
            image: UIImage(systemName: "wind"),
            topText: "Wind",
            windDegree: viewModel.getWindDegree(),
            windDirection: viewModel.getDirection(),
            windSpeed: "\(viewModel.getWindSpeed())",
            gustSpeed: "\(viewModel.getGustSpeed())"
        )
        collectionView.reloadData()
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension WeatherViewController: WeatherViewModelDelegate {
    func didUpdateWeatherData() {
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    
    func cantFetchData(errorMessage: String) {
        showAlert(title: "Error", message: errorMessage)
    }
}
