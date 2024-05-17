//
//  SolarResourceViewController.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.
//
import UIKit

class SolarResourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Variables
    var viewModel: SolarResourceViewModel
    var expandedRows = Set<Int>()
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let addressTextField = UITextField()
    
    private let fetchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Fetch Data", for: .normal)
        button.addTarget(self, action: #selector(fetchData), for: .touchUpInside)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ExpandableTableViewCell.self, forCellReuseIdentifier: ExpandableTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var cardsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupLayout()
        setupCollectionView()
        initTable()
        setupData()
        styleButton()
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
        tableView.isHidden = true
    }
    
    func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Content view constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [
            addressTextField,
            fetchButton,
            tableView,
            cardsCollection
        ])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            // Stack view constraints
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Cards collection height constraint
            cardsCollection.heightAnchor.constraint(greaterThanOrEqualToConstant: 1400)
        ])
        
        styleTextField(addressTextField, placeholder: "Enter US Address")
        
        // TableView Constraints
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    func initTable() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func styleTextField(_ textfield: UITextField, placeholder: String) {
        textfield.placeholder = placeholder
        textfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .font: UIFont(name: "FiraGO-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        ])
        textfield.textColor = .label
        textfield.backgroundColor = .clear
        textfield.layer.borderColor = UIColor.placeholderText.cgColor
        textfield.layer.borderWidth = 1.0
        textfield.layer.cornerRadius = 9
        textfield.borderStyle = .roundedRect
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func styleButton() {
        fetchButton.backgroundColor = UIColor.systemBlue
        fetchButton.setTitle("Check", for: .normal)
        fetchButton.setTitleColor(.white, for: .normal)
        fetchButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: fetchButton.titleLabel?.font.pointSize ?? 17)
        fetchButton.backgroundColor = UIColor.systemBlue
        fetchButton.layer.cornerRadius = 10
        fetchButton.translatesAutoresizingMaskIntoConstraints = false
        fetchButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupCollectionView() {
        cardsCollection.dataSource = self
        cardsCollection.delegate = self
        cardsCollection.register(CustomCardCell.self, forCellWithReuseIdentifier: CustomCardCell.identifier)
        cardsCollection.backgroundColor = .clear
    }
    
    // MARK: - Helper Functions
    func setupData() {
        viewModel.dataFetched = { [weak self] data in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.cardsCollection.reloadData()
                self?.tableView.isHidden = false
            }
        }
    }
    
    @objc func fetchData() {
        guard let address = addressTextField.text, !address.isEmpty else { return }
        viewModel.fetchSolarData(for: address)
    }
    
    @objc func reloadTable() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // MARK: - TableView DataSource and Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableTableViewCell.identifier, for: indexPath) as! ExpandableTableViewCell
        guard let solarData = viewModel.solarData else {
            return cell
        }
        
        switch indexPath.row {
        case 0:
            cell.configure(with: "Average Direct Normal Irradiance", annualValue: solarData.avgDniAnnual, monthlyData: solarData.avgDniMonthly)
        case 1:
            cell.configure(with: "Average Global Horizontal Irradiance", annualValue: solarData.avgGhiAnnual, monthlyData: solarData.avgGhiMonthly)
        case 2:
            cell.configure(with: "Average Tilt at Latitude", annualValue: solarData.avgTiltAnnual, monthlyData: solarData.avgTiltMonthly)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpandableTableViewCell else {
            return UITableView.automaticDimension
        }
        return cell.isExpanded ? 400 : 60
    }
}

// MARK: - Extensions for CollectionView
extension SolarResourceViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return solarResourceInfoCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCardCell.identifier, for: indexPath) as! CustomCardCell
        let card = solarResourceInfoCards[indexPath.item]
        cell.configure(with: card)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let collectionViewWidth = collectionView.frame.width
        let itemWidth = collectionViewWidth - 2 * padding
        return CGSize(width: itemWidth, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding: CGFloat = 16
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
