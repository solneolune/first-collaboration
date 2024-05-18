//
//  SolarDataCell.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 18.05.24.
//

import UIKit

class SolarDataCell: UITableViewCell {
    static let identifier = "SolarDataCell"
    
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let descriptionStackView = UIStackView()
    
    var isExpanded: Bool = false {
        didSet {
            descriptionStackView.isHidden = !isExpanded
            setNeedsUpdateConstraints()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        valueLabel.font = UIFont.systemFont(ofSize: 16)
        valueLabel.textColor = .label
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(valueLabel)
        
        descriptionStackView.axis = .vertical
        descriptionStackView.spacing = 5
        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            descriptionStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            descriptionStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        descriptionStackView.isHidden = true
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        let descriptionBottomConstraint = descriptionStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        descriptionBottomConstraint.priority = .required
        descriptionBottomConstraint.isActive = isExpanded
        
        // Ensure a minimum height when not expanded
        if !isExpanded {
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        }
    }
    
    func configure(withTitle title: String, value: String, description: String) {
        titleLabel.text = title
        valueLabel.text = value
        
        descriptionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let lines = description.split(separator: "\n")
        for line in lines {
            let components = line.split(separator: ":")
            if components.count == 2 {
                let month = String(components[0]).trimmingCharacters(in: .whitespaces)
                let value = String(components[1]).trimmingCharacters(in: .whitespaces)
                
                let descriptionLine = createDescriptionLine(month: month, value: value)
                descriptionStackView.addArrangedSubview(descriptionLine)
            }
        }
    }
    
    private func createDescriptionLine(month: String, value: String) -> UIView {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        let monthLabel = UILabel()
        monthLabel.font = UIFont.boldSystemFont(ofSize: 14)
        monthLabel.textColor = .label
        monthLabel.text = month
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        lineView.addSubview(monthLabel)
        
        let valueLabel = UILabel()
        valueLabel.font = UIFont.systemFont(ofSize: 14)
        valueLabel.textColor = .label
        valueLabel.text = value
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        lineView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            monthLabel.leadingAnchor.constraint(equalTo: lineView.leadingAnchor),
            monthLabel.centerYAnchor.constraint(equalTo: lineView.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: lineView.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: lineView.centerYAnchor),
            
            lineView.heightAnchor.constraint(equalTo: monthLabel.heightAnchor)
        ])
        
        return lineView
    }
}
