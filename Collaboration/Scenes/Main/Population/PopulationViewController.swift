//
//  PopulationViewController.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.

import UIKit

class PopulationViewController: UIViewController {
    
    // MARK: - Variables
    var viewModel: PopulationViewModel
    let populationService = PopulationService()
    
    // MARK: - UI Components
    var populationTextField = UITextField()
    var populationButton = UIButton()
    var todayLabel = UILabel()
    var tomorrowLabel = UILabel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
    }
    
    init(viewModel: PopulationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    func setupUI() {
        // Configure populationTextField
        populationTextField.placeholder = "Enter country name"
        populationTextField.borderStyle = .roundedRect
        populationTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(populationTextField)
        
        // Configure populationButton
        populationButton.setTitle("Fetch Population", for: .normal)
        populationButton.backgroundColor = .systemBlue
        populationButton.setTitleColor(.white, for: .normal)
        populationButton.layer.cornerRadius = 5
        populationButton.addTarget(self, action: #selector(fetchPopulationData), for: .touchUpInside)
        populationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(populationButton)
        
        // Configure todayLabel
        todayLabel.numberOfLines = 0
        todayLabel.textAlignment = .center
        todayLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(todayLabel)
        
        // Configure tomorrowLabel
        tomorrowLabel.numberOfLines = 0
        tomorrowLabel.textAlignment = .center
        tomorrowLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tomorrowLabel)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            populationTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            populationTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            populationTextField.widthAnchor.constraint(equalToConstant: 200),
            populationTextField.heightAnchor.constraint(equalToConstant: 40),
            
            populationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            populationButton.topAnchor.constraint(equalTo: populationTextField.bottomAnchor, constant: 20),
            populationButton.widthAnchor.constraint(equalToConstant: 150),
            populationButton.heightAnchor.constraint(equalToConstant: 50),
            
            todayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            todayLabel.topAnchor.constraint(equalTo: populationButton.bottomAnchor, constant: 20),
            todayLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            
            tomorrowLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tomorrowLabel.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 20),
            tomorrowLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
        ])
    }
    
    // MARK: - Fetch Population Data
    @objc func fetchPopulationData() {
        guard let country = populationTextField.text, !country.isEmpty else {
            todayLabel.text = "Please enter a country name."
            tomorrowLabel.text = ""
            return
        }
        
        populationService.fetchPopulation(for: country) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    
                    let todayDate = response?.total_population[0].date
                    let tommorowDate = response?.total_population[1].date
                    let todayPopulation = response?.total_population[0].population
                    let tomorrowPopulation = response?.total_population[1].population
                    
                    self?.todayLabel.text = "\(String(describing: todayDate!))  \(String(describing: todayPopulation!))"
                    self?.tomorrowLabel.text = "\(String(describing: tommorowDate!))  \(String(describing: tomorrowPopulation!))"
                    
                case .failure(let error):
                    self?.todayLabel.text = "Error: \(error)"
                    self?.tomorrowLabel.text = ""
                }
            }
        }
    }
}
