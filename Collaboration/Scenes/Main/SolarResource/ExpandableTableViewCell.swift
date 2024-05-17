//
//  ExpandableTableViewCell.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.
//

import UIKit

class ExpandableTableViewCell: UITableViewCell {
    static let identifier = "ExpandableTableViewCell"
    
    let titleLabel = UILabel()
    let annualValueLabel = UILabel()
    let expandButton = UIButton(type: .system)
    var monthlyTableView = UITableView()
    var isExpanded = false

    var monthlyData: [String: Double] = [:] {
        didSet {
            monthlyTableView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        annualValueLabel.translatesAutoresizingMaskIntoConstraints = false
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        monthlyTableView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(annualValueLabel)
        contentView.addSubview(expandButton)
        contentView.addSubview(monthlyTableView)
        
        expandButton.setTitle("+", for: .normal)
        expandButton.addTarget(self, action: #selector(toggleExpand), for: .touchUpInside)
        
        monthlyTableView.dataSource = self
        monthlyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MonthlyCell")
        monthlyTableView.isHidden = true
        
        NSLayoutConstraint.activate([
            expandButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            expandButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            annualValueLabel.leadingAnchor.constraint(equalTo: expandButton.trailingAnchor, constant: 10),
            annualValueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: annualValueLabel.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            monthlyTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            monthlyTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            monthlyTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            monthlyTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    @objc func toggleExpand() {
        isExpanded.toggle()
        monthlyTableView.isHidden = !isExpanded
        expandButton.setTitle(isExpanded ? "-" : "+", for: .normal)
        // Notify the table view to update the cell height
        NotificationCenter.default.post(name: NSNotification.Name("ExpandCollapseNotification"), object: nil)
    }
    
    func configure(with title: String, annualValue: Double, monthlyData: [String: Double]) {
        titleLabel.text = title
        annualValueLabel.text = String(format: "%.2f", annualValue)
        self.monthlyData = monthlyData
    }
}

extension ExpandableTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthlyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonthlyCell", for: indexPath)
        let month = Array(monthlyData.keys)[indexPath.row]
        let value = monthlyData[month]!
        cell.textLabel?.text = "\(month.capitalized): \(value)"
        return cell
    }
}
