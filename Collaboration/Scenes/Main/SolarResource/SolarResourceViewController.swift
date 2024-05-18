import UIKit

class SolarResourceViewController: UIViewController {
    // MARK: - Variables
    var viewModel: SolarResourceViewModel
    var expandedRows = Set<Int>()
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let addressInputView = CustomInputView()

    private let fetchButton: CustomButton = {
        let button = CustomButton(title: "Fetch Data", backgroundColor: .systemBlue)
        button.addTarget(self, action: #selector(fetchData), for: .touchUpInside)
        return button
    }()
    
    private let tableContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SolarDataCell.self, forCellReuseIdentifier: SolarDataCell.identifier)
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
    
    private var tableContainerHeightConstraint: NSLayoutConstraint!
    private var cardsCollectionHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupLayout()
        setupCollectionView()
        initTable()
        setupData()
        observeTableViewContentSize()
        observeCollectionViewContentSize()
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
        view.backgroundColor = .systemGray6
    }
    
    func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(tableContainerView)
        tableContainerView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [
            addressInputView,
            fetchButton,
            tableContainerView,
            cardsCollection
        ])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
        ])
        
        tableContainerHeightConstraint = tableContainerView.heightAnchor.constraint(equalToConstant: 0)
        tableContainerHeightConstraint.isActive = true
        
        cardsCollectionHeightConstraint = cardsCollection.heightAnchor.constraint(equalToConstant: 0)
        cardsCollectionHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: tableContainerView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor),
            
            fetchButton.heightAnchor.constraint(equalToConstant: 45),
            addressInputView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func initTable() {
        tableView.delegate = self
        tableView.dataSource = self
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
                self?.tableContainerView.isHidden = false
                self?.updateTableContainerHeight()
                self?.updateCollectionViewHeight()
            }
        }
    }
    
    func updateTableContainerHeight() {
        let tableContentHeight = tableView.contentSize.height
        tableContainerHeightConstraint.constant = tableContentHeight
    }
    
    func updateCollectionViewHeight() {
        let collectionContentHeight = cardsCollection.collectionViewLayout.collectionViewContentSize.height
        cardsCollectionHeightConstraint.constant = collectionContentHeight
    }
    
    @objc func fetchData() {
        guard let address = addressInputView.text, !address.isEmpty else { return }
        viewModel.fetchSolarData(for: address)
    }
    
    func observeTableViewContentSize() {
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func observeCollectionViewContentSize() {
        cardsCollection.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if object as? UITableView == tableView {
                updateTableContainerHeight()
            } else if object as? UICollectionView == cardsCollection {
                updateCollectionViewHeight()
            }
        }
    }
    
    deinit {
        tableView.removeObserver(self, forKeyPath: "contentSize")
        cardsCollection.removeObserver(self, forKeyPath: "contentSize")
    }
}

// MARK: - Extension for TableView
extension SolarResourceViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SolarDataCell.identifier, for: indexPath) as? SolarDataCell else {
            return UITableViewCell()
        }
        
        guard let solarData = viewModel.solarData else { return cell }
        
        var title = ""
        var value = ""
        var description = ""
        
        switch indexPath.row {
        case 0:
            title = "Average Direct Normal Irradiance"
            value = "\(solarData.avgDniAnnual)"
            description = solarData.avgDniMonthly.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
        case 1:
            title = "Average Global Horizontal Irradiance"
            value = "\(solarData.avgGhiAnnual)"
            description = solarData.avgGhiMonthly.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
        case 2:
            title = "Average Tilt at Latitude"
            value = "\(solarData.avgTiltAnnual)"
            description = solarData.avgTiltMonthly.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
        default:
            break
        }
        
        cell.configure(withTitle: title, value: value, description: description)
        cell.isExpanded = expandedRows.contains(indexPath.row)
        
        return cell
    }
    
    // MARK: - UITableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if expandedRows.contains(indexPath.row) {
            expandedRows.remove(indexPath.row)
        } else {
            expandedRows.insert(indexPath.row)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return expandedRows.contains(indexPath.row) ? UITableView.automaticDimension : 50
    }
}

// MARK: - Extension for CollectionView
extension SolarResourceViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return solarResourceInfoCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCardCell.identifier, for: indexPath) as! CustomCardCell
        let card = solarResourceInfoCards[indexPath.item]
        cell.configure(with: card)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let itemWidth = collectionViewWidth
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
