//
//  AirQualityViewController.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.
//

import UIKit

class AirQualityViewController: UIViewController {
    // MARK: - Variables

    var viewModel: AirQualityViewModel
    let lineLayer = CAGradientLayer()
    let indicatorView = UIView()

    // MARK: - UI Components

    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 15
        textField.backgroundColor = UIColor(named: "textFieldColor") ?? .lightGray
        textField.textColor = .black
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.autocorrectionType = .no
        return textField
    }()

    let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .lightGray
        button.setTitle("Search", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()

    let pollutionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 26)
        label.text = ""
        return label
    }()

    let pollutionStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 26)
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let pollutionInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "tttt"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()

    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupData()
        bindViewModel()
        view.backgroundColor = .white
    }

    init(viewModel: AirQualityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindViewModel() {
        viewModel.updateUI = { [weak self] in
            guard let self = self, let info = self.viewModel.airQualityInfo else { return }
            print("City: \(info.data.city), State: \(info.data.state)")

            let pollution = info.data.current.pollution
            let temperature = info.data.current.weather
            print("Pollution: \(pollution.aqius)")
            pollutionLabel.text = "\(pollution.aqius)"
            print("temperature: \(temperature.tp)")
            self.updateBarIndicator(to: CGFloat(pollution.aqius))
            self.loadingIndicator.stopAnimating()
        }
    }

    // MARK: - UI Setup

    func setupLayout() {
        // MARK: - Helper Functions

        configureTextField()
        configureButton()
        configureLabel()
        configureBarIndicator()
        configureStatusLabel()
//        configurePollutionInfoLayer()
        configureBottomView()
        configureLoadingIndicator()
    }

    func configureBarIndicator() {
        lineLayer.frame = CGRect(x: 50, y: 400, width: 300, height: 4)
        lineLayer.colors = [UIColor.green.cgColor, UIColor.red.cgColor]
        lineLayer.startPoint = CGPoint(x: 0, y: 0.5)
        lineLayer.endPoint = CGPoint(x: 1, y: 0.5)
        view.layer.addSublayer(lineLayer)
        let indicatorSize: CGFloat = 10
        indicatorView.frame = CGRect(x: 50 - indicatorSize / 4, y: 400 - indicatorSize / 4, width: indicatorSize, height: indicatorSize)
        indicatorView.backgroundColor = UIColor.black
        indicatorView.layer.cornerRadius = indicatorSize / 2
        view.addSubview(indicatorView)
    }

    func configureTextField() {
        view.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            searchTextField.widthAnchor.constraint(equalToConstant: 327),
            searchTextField.heightAnchor.constraint(equalToConstant: 45),
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        ])
    }

    func configureButton() {
        searchButton.addAction(UIAction(handler: { _ in
            self.clickButton()
        }), for: .touchUpInside)
        view.addSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 50),
            searchButton.widthAnchor.constraint(equalToConstant: 90),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        ])
    }

    func configureLabel() {
        view.addSubview(pollutionLabel)
        NSLayoutConstraint.activate([
            pollutionLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 250),
            pollutionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        ])
    }

    func configureStatusLabel() {
        view.addSubview(pollutionStatusLabel)
        NSLayoutConstraint.activate([
            pollutionStatusLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 350),
            pollutionStatusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pollutionStatusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pollutionStatusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        ])
    }

//    func configurePollutionInfoLayer() {
//    //        pollutionInfoLabel.text = "Air quality is \()"
//        view.addSubview(bottomView)
//        NSLayoutConstraint.activate([
//            pollutionInfoLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
//            pollutionInfoLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
//            pollutionInfoLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10),
//            pollutionInfoLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -10),
//
//        ])
//    }

    func configureBottomView() {
        view.addSubview(bottomView)

        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: pollutionStatusLabel.topAnchor, constant: 90),
//            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            bottomView.widthAnchor.constraint(equalToConstant: 50),
            bottomView.heightAnchor.constraint(equalToConstant: 130),
        ])
    }

    func configureLoadingIndicator() {
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    func setupData() {
    }

    func clickButton() {
        loadingIndicator.startAnimating()
        viewModel.fetchCoordinates(city: searchTextField.text ?? "") { [weak self] latitude, longitude in
            self?.viewModel.fetchAirQualityInfo(lat: latitude, lon: longitude)
        }
    }

    func updateBarIndicator(to value: CGFloat) {
        let maxValue: CGFloat = 180
        let clampedValue = min(max(value, 0), maxValue)
        var positionX: CGFloat

        if value > maxValue {
            positionX = lineLayer.frame.maxX
        } else {
            positionX = 50 + (lineLayer.frame.width - 50) * (clampedValue / maxValue)
        }

        UIView.animate(withDuration: 0.5) {
            self.indicatorView.center.x = positionX
        }
        var status = ""
        if value < 50 {
            status = "Air quality is good"
        } else if value < 100 {
            status = "Air quality is moderate"
        } else if value < 150 {
            status = "Air quality is unhealthy for sensitive groups"
        } else if value < 200 {
            status = "Air quality is unhealthy"
        } else if value < 300 {
            status = "Air quality is very unhealthy"
        } else {
            status = "Air quality is hazardous"
        }
        pollutionStatusLabel.text = status
    }
}
