//
//  PopulationViewController.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.
//
import UIKit

class PopulationViewController: UIViewController {
    // MARK: - Variables
    var viewModel: PopulationViewModel
    
    // MARK: - UI Components
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupData()
        view.backgroundColor = .blue
    }
    
    init(viewModel: PopulationViewModel) {
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
