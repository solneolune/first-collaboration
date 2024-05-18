//
//  SpecieViewController.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.
//
import UIKit
import BarbareDoesNetworking

class SpecieViewController: UIViewController{
    // MARK: - Variables
    var viewModel: SpecieViewModel
    let networkService = NetworkService()
    var observations: [Observation] = []
    
    // MARK: - UI Components
    
    let reviewOfPage: UILabel = {
        let label = UILabel()
        label.text = "This page will record a city and \nreturn you the last found species of \nanimals and plants in that city."
        label.textColor = .systemGray2
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var cityNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a city"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.returnKeyType = .go
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        let imageView = UIImageView(image: UIImage(systemName: "globe.europe.africa.fill"))
        imageView.tintColor = .systemGray5
        textField.leftView = imageView
        textField.leftViewMode = .always
        return textField
    }()

    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let cityIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let line: UIView = {
        let line = UIView()
        line.backgroundColor = .systemGray4
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    let tableViewOfInformation: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SpecieTableViewCell.self, forCellReuseIdentifier: "SpecieTableViewCell")
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        addSubviews()
        setupConstraints()
        testActions()
        tableViewOfInformation.dataSource = self
        tableViewOfInformation.delegate = self
    }
    
    init(viewModel: SpecieViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    func addSubviews() {
        view.addSubview(reviewOfPage)
        view.addSubview(cityNameTextField)
        view.addSubview(searchButton)
        view.addSubview(cityIdLabel)
        view.addSubview(tableViewOfInformation)
        view.addSubview(line)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            reviewOfPage.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            reviewOfPage.bottomAnchor.constraint(equalTo: cityNameTextField.topAnchor, constant: -20),
            reviewOfPage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            reviewOfPage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            
            cityNameTextField.heightAnchor.constraint(equalToConstant: 40),
            cityNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cityNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchButton.leadingAnchor.constraint(equalTo: cityNameTextField.trailingAnchor, constant: 16),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchButton.widthAnchor.constraint(equalToConstant: 80),
            
            cityIdLabel.topAnchor.constraint(equalTo: cityNameTextField.bottomAnchor, constant: 20),
            cityIdLabel.leadingAnchor.constraint(equalTo: cityNameTextField.leadingAnchor),
            
            line.heightAnchor.constraint(equalToConstant: 2),
            line.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            line.bottomAnchor.constraint(equalTo: tableViewOfInformation.topAnchor),
            
            tableViewOfInformation.topAnchor.constraint(equalTo: cityIdLabel.bottomAnchor, constant: 20),
            tableViewOfInformation.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewOfInformation.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewOfInformation.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Helper Functions
    func setupData() {
        
    }
    
    // MARK: - Action
    func testActions() {
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }

    @objc func searchButtonTapped() {
        guard let cityName = cityNameTextField.text, !cityName.isEmpty else {
            cityIdLabel.text = "Please enter a city name"
            return
        }
        fetchCountryCoordinates(city: cityName)
    }

    func fetchCountryCoordinates(city: String) {
        guard let url = URL(string: "https://api.inaturalist.org/v1/places/autocomplete?q=\(city)") else {
            fatalError("Invalid URL")
        }

        networkService.fetch(url: url, parse: { data -> AutocompleteResponse? in
            return try? JSONDecoder().decode(AutocompleteResponse.self, from: data)
        }) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cityData):
                    self?.cityIdLabel.text = "City: \(city)"
                    self?.fetchCountryData(cityID: cityData?.results.first?.id ?? 0)
                case .failure(let error):
                    print("Error fetching city ID:", error)
                }
            }
        }
    }


    func fetchCountryData(cityID: Int) {
        guard let url = URL(string: "https://api.inaturalist.org/v1/observations/species_counts?place_id=\(cityID)") else {
            fatalError("Invalid URL")
        }

        networkService.fetch(url: url, parse: { data -> SpeciesCountsResponse? in
            do {
                let speciesData = try JSONDecoder().decode(SpeciesCountsResponse.self, from: data)
                return speciesData
            } catch {
                print("Error decoding species counts data:", error)
                return nil
            }
        }) { [weak self] result in
            switch result {
            case .success(let speciesData):
                if let observations = speciesData?.results {
                    self?.observations = observations
                    DispatchQueue.main.async {
                        self?.tableViewOfInformation.reloadData()
                    }
                } else {
                    print("No observations found.")
                }
            case .failure(let error):
                print("Error fetching species counts:", error)
            }
        }
    }
}
