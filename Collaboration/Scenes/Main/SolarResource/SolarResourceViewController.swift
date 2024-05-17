//
//  SolarResourceViewController.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.
//
import UIKit

class SolarResourceViewController: UIViewController {
    // MARK: - Variables
    var viewModel: SolarResourceViewModel
    
    // MARK: - UI Components
    private let addressTextField = UITextField()
    
    private let fetchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Fetch Data", for: .normal)
        button.addTarget(self, action: #selector(fetchData), for: .touchUpInside)
        return button
    }()
    
    private let resultsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupLayout()
        setupData()
    }
    
    init(viewModel: SolarResourceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    func updateUI() {
        view.backgroundColor = .systemBackground
    }
    
    func setupLayout() {
        initStackView()
        initTextField()
    }
    
    func initStackView() {
         let stackView = UIStackView(arrangedSubviews: [
             addressTextField,
             fetchButton,
             resultsLabel
         ])
         stackView.axis = .vertical
         stackView.distribution = .fill
         let screenSize = UIScreen.main.bounds.size
         let spacing = screenSize.width < 410 ? 20 : 25
         stackView.spacing = CGFloat(spacing)
         stackView.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(stackView)
         NSLayoutConstraint.activate([
             stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
             stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
             stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
             stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
         ])
     }
    
    func initTextField() {
        styleTextField(addressTextField, placeholder: "Enter US Address")
    }
    
    func styleTextField(_ textfield: UITextField, placeholder: String) {
        textfield.placeholder = placeholder
        textfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .font: UIFont(name: "FiraGO-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        ])
        textfield.textColor = .label
        textfield.backgroundColor = .clear
        textfield.layer.borderColor = UIColor.label.cgColor
        textfield.layer.borderWidth = 1.0
        textfield.layer.cornerRadius = 9
        textfield.borderStyle = .roundedRect
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    // MARK: - Helper Functions
    func setupData() {
        viewModel.dataFetched = { [weak self] data in
            DispatchQueue.main.async {
                self?.resultsLabel.text = data
            }
        }
    }
    
    @objc func fetchData() {
        guard let address = addressTextField.text, !address.isEmpty else { return }
        viewModel.fetchSolarData(for: address)
    }
}
