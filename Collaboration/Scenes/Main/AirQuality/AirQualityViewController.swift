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
    var status = ""
    var currentCityName: String?

    // MARK: - UI Components

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemGray6
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    let contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .systemGray6
        return contentView
    }()

    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.textColor = UIColor.label
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.autocorrectionType = .no
        textField.backgroundColor = .systemBackground
        textField.layer.borderColor = UIColor.black.cgColor
        textField.placeholder = "City name"
        return textField
    }()

    let searchButton = CustomButton(
        title: "Search",
        backgroundColor: .black,
        titleColor: .white,
        cornerRadius: 10
    )

    let pollutionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.label
        label.font = UIFont.systemFont(ofSize: 26)
        label.text = ""
        return label
    }()

    let pollutionStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.label
        label.font = UIFont.systemFont(ofSize: 26)
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let pollutionInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.label
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = TextResources.Standards_Desc.pollutionInfo
        label.numberOfLines = 0
        return label
    }()

    let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()

    func createBlockView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }

    lazy var blockView1: UIView = createBlockView()
    lazy var blockView2: UIView = createBlockView()
    lazy var blockView3: UIView = createBlockView()
    lazy var blockView4: UIView = createBlockView()
    lazy var blockView5: UIView = createBlockView()
    lazy var blockView6: UIView = createBlockView()

    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindViewModel()
        setupUI()

        title = "Air Pollution"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    init(viewModel: AirQualityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindViewModel() {
        pollutionStatusLabel.text = ""
        viewModel.updateUI = { [weak self] in
            guard let self = self, let info = self.viewModel.airQualityInfo else { return }
            print("City: \(info.data.city), State: \(info.data.state)")

            let pollution = info.data.current.pollution
            let temperature = info.data.current.weather
            print("Pollution: \(pollution.aqius)")
            self.pollutionLabel.text = "\(pollution.aqius)"
            print("temperature: \(temperature.tp)")
            self.loadingIndicator.stopAnimating()
            self.updateBarIndicator(to: CGFloat(pollution.aqius))
        }
    }

    // MARK: - UI Setup

    func setupUI() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: 180),
        ])
    }

    func setupLayout() {
        configureTextField()
        configureButton()
        configureLabel()
        configureBarIndicator()
        configureStatusLabel()
        configureBottomView()
        configurePollutionInfoLayer()
        configureLoadingIndicator()
        configureBlockViews()
    }

    func configureBarIndicator() {
        let width = view.frame.width
        print(width)
        lineLayer.frame = CGRect(x: 25, y: 115, width: width - 50, height: 4)
        lineLayer.colors = [UIColor.green.cgColor, UIColor.red.cgColor]
        lineLayer.startPoint = CGPoint(x: 0, y: 0.5)
        lineLayer.endPoint = CGPoint(x: 1, y: 0.5)
        contentView.layer.addSublayer(lineLayer)
        let indicatorSize: CGFloat = 10
        indicatorView.frame = CGRect(x: 25 - indicatorSize / 4, y: 115 - indicatorSize / 4, width: indicatorSize, height: indicatorSize)
        indicatorView.backgroundColor = UIColor.label
        indicatorView.layer.cornerRadius = indicatorSize / 2
        contentView.addSubview(indicatorView)
    }

    func configureTextField() {
        contentView.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            searchTextField.widthAnchor.constraint(equalToConstant: 327),
            searchTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    func configureButton() {
        searchButton.addAction(UIAction(handler: { _ in
            self.clickButton()
        }), for: .touchUpInside)
        contentView.addSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            searchButton.widthAnchor.constraint(equalToConstant: 90),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            searchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            searchButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 16),

        ])
    }

    func configureLabel() {
        contentView.addSubview(pollutionLabel)
        NSLayoutConstraint.activate([
            pollutionLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 96),
            pollutionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }

    func configureStatusLabel() {
        contentView.addSubview(pollutionStatusLabel)
        NSLayoutConstraint.activate([
            pollutionStatusLabel.topAnchor.constraint(equalTo: pollutionLabel.bottomAnchor, constant: 20),
            pollutionStatusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            pollutionStatusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            pollutionStatusLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }

    func configureBottomView() {
        contentView.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: pollutionStatusLabel.bottomAnchor, constant: 25),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bottomView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }

    func configureBlockView(_ blockView: UIView, titleText: String, descriptionText: String, isLeft: Bool, anchorView: UIView?) {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = titleText
        title.textColor = UIColor.label
        title.numberOfLines = 0
        title.font = UIFont.boldSystemFont(ofSize: 17)

        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.text = descriptionText
        description.font = UIFont.systemFont(ofSize: 13)
        description.textColor = UIColor.label
        description.numberOfLines = 0

        blockView.addSubview(title)
        blockView.addSubview(description)
        contentView.addSubview(blockView)

        let width: CGFloat = view.frame.width / 2 - 24

        NSLayoutConstraint.activate([
            blockView.heightAnchor.constraint(equalToConstant: width),
            blockView.widthAnchor.constraint(equalToConstant: width),
        ])

        if isLeft {
            blockView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        } else {
            blockView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        }

        if let anchorView = anchorView {
            NSLayoutConstraint.activate([
                blockView.topAnchor.constraint(equalTo: anchorView.bottomAnchor, constant: 16),
            ])
        } else {
            NSLayoutConstraint.activate([
                blockView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            ])
        }

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: blockView.topAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: blockView.trailingAnchor, constant: -10),
        ])
        NSLayoutConstraint.activate([
            description.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            description.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: 10),
            description.trailingAnchor.constraint(equalTo: blockView.trailingAnchor, constant: -10),
            description.bottomAnchor.constraint(equalTo: blockView.bottomAnchor, constant: -10),
        ])
    }

    func configureBlockViews() {
        configureBlockView(blockView1, titleText: TextResources.Standards.good, descriptionText: TextResources.Standards_Desc.good_desc, isLeft: true, anchorView: bottomView)
        configureBlockView(blockView2, titleText: TextResources.Standards.moderate, descriptionText: TextResources.Standards_Desc.moderate_desc, isLeft: false, anchorView: bottomView)
        configureBlockView(blockView3, titleText: TextResources.Standards.unhealthyForSensitiveGroups, descriptionText: TextResources.Standards_Desc.unhealthyForSensitiveGroups_desc, isLeft: true, anchorView: blockView1)
        configureBlockView(blockView4, titleText: TextResources.Standards.unhealthy, descriptionText: TextResources.Standards_Desc.unhealthy_desc, isLeft: false, anchorView: blockView2)
        configureBlockView(blockView5, titleText: TextResources.Standards.veryUnhealthy, descriptionText: TextResources.Standards_Desc.veryUnhealthy_desc, isLeft: true, anchorView: blockView3)
        configureBlockView(blockView6, titleText: TextResources.Standards.hazardous, descriptionText: TextResources.Standards_Desc.hazardous_desc, isLeft: false, anchorView: blockView4)
    }

    func configurePollutionInfoLayer() {
        bottomView.addSubview(pollutionInfoLabel)
        NSLayoutConstraint.activate([
            pollutionInfoLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
            pollutionInfoLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
            pollutionInfoLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10),
            pollutionInfoLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -10),
        ])
    }

    func configureLoadingIndicator() {
        contentView.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 76),
        ])
    }

    func clickButton() {
        loadingIndicator.startAnimating()
        guard let cityName = searchTextField.text, !cityName.isEmpty else {
            status = "Text field is empty"
            pollutionStatusLabel.text = status
            loadingIndicator.stopAnimating()
            return
        }
        currentCityName = cityName
        pollutionStatusLabel.text = ""
        pollutionLabel.text = ""

        viewModel.fetchCoordinates(city: cityName) { [weak self] latitude, longitude in
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

        if value < 50 {
            status = "Air quality in \(searchTextField.text ?? "") is good"
        } else if value < 100 {
            status = "Air quality in \(searchTextField.text ?? "") is moderate"
        } else if value < 150 {
            status = "Air quality in \(searchTextField.text ?? "") is unhealthy for sensitive groups"
        } else if value < 200 {
            status = "Air quality in \(searchTextField.text ?? "") is unhealthy"
        } else if value < 300 {
            status = "Air quality in \(searchTextField.text ?? "") is very unhealthy"
        } else {
            status = "Air quality in \(searchTextField.text ?? "") is hazardous"
        }
        pollutionStatusLabel.text = status
    }
}
