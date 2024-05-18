//
//  PopulationViewController.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.


import UIKit

class PopulationViewController: UIViewController {
    
    // MARK: - Variables
    
    var viewModel: PopulationViewModel
    
    // MARK: - UI Components
    var populationTextField = UITextField()
    var populationButton = UIButton()
    var todayLabel = UILabel()
    var tomorrowLabel = UILabel()
    var todayPopulationView = LongLayoutView()
    var tomorrowPopulationView = LongLayoutView()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.viewModel.delegate = self
        setupBindings()
        view.backgroundColor = .systemGray6
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
        
        //Configure todayPopulationView
        
        todayPopulationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(todayPopulationView)
        
        //Configure tomorrowPopulationView
        tomorrowPopulationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tomorrowPopulationView)
        
        // Configure populationTextField
        populationTextField.placeholder = "Enter country name"
        populationTextField.translatesAutoresizingMaskIntoConstraints = false
        populationTextField.clipsToBounds = true
        populationTextField.layer.cornerRadius = 10
        populationTextField.backgroundColor = .systemBackground
        populationTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: populationTextField.frame.height))
        populationTextField.leftViewMode = .always
        view.addSubview(populationTextField)
        
        // Configure populationButton
        populationButton.setTitle("Fetch Data", for: .normal)
        populationButton.backgroundColor = .systemPink
        populationButton.setTitleColor(.white, for: .normal)
        populationButton.layer.cornerRadius = 5
        populationButton.addAction(UIAction(handler: { _ in
            self.fetchPopulationData()
        }), for: .touchUpInside)
        populationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(populationButton)
        
        // Configure todayLabel
        todayLabel.numberOfLines = 0
        todayLabel.textAlignment = .center
        todayLabel.translatesAutoresizingMaskIntoConstraints = false
        todayLabel.backgroundColor = UIColor.lightGray
        todayLabel.clipsToBounds = true
        todayLabel.layer.cornerRadius = 10
        view.addSubview(todayLabel)
        
        // Configure tomorrowLabel
        tomorrowLabel.numberOfLines = 0
        tomorrowLabel.textAlignment = .center
        tomorrowLabel.translatesAutoresizingMaskIntoConstraints = false
        tomorrowLabel.backgroundColor = UIColor.lightGray
        tomorrowLabel.clipsToBounds = true
        tomorrowLabel.layer.cornerRadius = 10
        view.addSubview(tomorrowLabel)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            populationTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            populationTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            populationTextField.heightAnchor.constraint(equalToConstant: 50),
            populationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            populationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            populationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            populationButton.topAnchor.constraint(equalTo: populationTextField.bottomAnchor, constant: 20),
            populationButton.widthAnchor.constraint(equalToConstant: 150),
            populationButton.heightAnchor.constraint(equalToConstant: 50),
            
            todayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            todayLabel.topAnchor.constraint(equalTo: populationButton.bottomAnchor, constant: 20),
            todayLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            
            tomorrowLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tomorrowLabel.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 20),
            tomorrowLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            
            todayPopulationView.topAnchor.constraint(equalTo: populationButton.bottomAnchor, constant: 10),
            todayPopulationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            todayPopulationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tomorrowPopulationView.topAnchor.constraint(equalTo: todayPopulationView.bottomAnchor, constant: 10),
            tomorrowPopulationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tomorrowPopulationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Setup Bindings
    func setupBindings() {
        
        viewModel.errorMessage = { [weak self] message in
            self?.todayLabel.text = message
            self?.tomorrowLabel.text = ""
        }
        
    }
    func updateUI(){
        todayPopulationView.configure(leftText: "Today Population", rightText: viewModel.todayPopulationText ?? "")
        tomorrowPopulationView.configure(leftText: "Tomorrow Population", rightText: viewModel.tomorrowPopulationText ?? "")
        
    }
    
    // MARK: - Fetch Population Data
    func fetchPopulationData() {
        guard let country = populationTextField.text, !country.isEmpty else {
            todayLabel.text = "Please enter a country name."
            tomorrowLabel.text = ""
            return
        }
        viewModel.fetchCountryWeatherData(country: country)
    }
}

extension PopulationViewController: PopulationViewModelDelegate {
    func didFetchData() {
        DispatchQueue.main.async {
            self.updateUI()
        }
        
    }
    
    
}

