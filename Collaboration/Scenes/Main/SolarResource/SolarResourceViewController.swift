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
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupData()
        view.backgroundColor = .orange
    }
    
    init(viewModel: SolarResourceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    func setupLayout() {
        NSLayoutConstraint.activate([
            
        ])
    }
    
    // MARK: - Helper Functions
    func setupData() {
        
    }
}
