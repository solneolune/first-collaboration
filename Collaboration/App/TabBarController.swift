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
        airQualityVC.tabBarItem.image = UIImage(systemName: "aqi.low")
        airQualityVC.tabBarItem.selectedImage = UIImage(systemName: "aqi.medium")
        
        weatherVC.tabBarItem.image = UIImage(systemName: "cloud.sun")
        weatherVC.tabBarItem.selectedImage = UIImage(systemName: "cloud.sun.fill")?.withRenderingMode(.alwaysTemplate)
        
        specieVC.tabBarItem.image = UIImage(systemName: "leaf")
        specieVC.tabBarItem.selectedImage = UIImage(systemName: "leaf.fill")?.withRenderingMode(.alwaysTemplate)
        
        solarResourceVC.tabBarItem.image = UIImage(systemName: "sun.max")
        solarResourceVC.tabBarItem.selectedImage = UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysTemplate)
        
        populationVC.tabBarItem.image = UIImage(systemName: "person.3")
        populationVC.tabBarItem.selectedImage = UIImage(systemName: "person.3.fill")?.withRenderingMode(.alwaysTemplate)
        

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
        
        tabBar.tintColor = .systemGray
        tabBar.backgroundColor = .systemGray6
        
        setViewControllers([nav1, nav2, nav3, nav4, nav5], animated: true)
    }
}

