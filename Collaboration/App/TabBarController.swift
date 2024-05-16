//
//  TabBarController.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.
//

import UIKit

class TabBarController: UITabBarController {
    // MARK: - Variables
    let airQualityVC = AirQualityViewController(viewModel: AirQualityViewModel())
    let weatherVC = WeatherViewController(viewModel: WeatherViewModel())
    let specieVC = SpecieViewController(viewModel: SpecieViewModel())
    let solarResourceVC = SolarResourceViewController(viewModel: SolarResourceViewModel())
    let populationVC = PopulationViewController(viewModel: PopulationViewModel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabs()
    }
    
    private func configureTabs() {
        
        
        //setup images
        airQualityVC.tabBarItem.image = UIImage(systemName: "house")
        airQualityVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        weatherVC.tabBarItem.image = UIImage(systemName: "cart")
        weatherVC.tabBarItem.selectedImage = UIImage(systemName: "cart.fill")?.withRenderingMode(.alwaysOriginal)
        
        specieVC.tabBarItem.image = UIImage(systemName: "person")
        specieVC.tabBarItem.selectedImage = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
        
        solarResourceVC.tabBarItem.image = UIImage(systemName: "cart")
        solarResourceVC.tabBarItem.selectedImage = UIImage(systemName: "cart.fill")?.withRenderingMode(.alwaysOriginal)
        
        populationVC.tabBarItem.image = UIImage(systemName: "person")
        populationVC.tabBarItem.selectedImage = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
        
        //setup title
//        airQualityVC.title = "Air Quality"
//        weatherVC.title = "Weather"
//        specieVC.title = "Specie"
//        solarResourceVC.title = "Solar Resource"
//        populationVC.title = "Population"
        
        let nav1 = UINavigationController(rootViewController: airQualityVC)
        let nav2 = UINavigationController(rootViewController: weatherVC)
        let nav3 = UINavigationController(rootViewController: specieVC)
        let nav4 = UINavigationController(rootViewController: solarResourceVC)
        let nav5 = UINavigationController(rootViewController: populationVC)
        
        tabBar.tintColor = UIColor(red: 172/255, green: 126/255, blue: 242/255, alpha: 1.0)
        tabBar.backgroundColor = .white
        
        tabBar.layer.borderWidth = 1.0
        tabBar.layer.borderColor = UIColor(red: 217/255, green: 208/255, blue: 227/255, alpha: 1.0).cgColor
        
        setViewControllers([nav1, nav2, nav3, nav4, nav5], animated: true)
    }
}

