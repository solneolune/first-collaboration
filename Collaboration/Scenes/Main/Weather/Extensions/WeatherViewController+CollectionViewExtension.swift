//
//  WeatherViewController+CollectionViewExtension.swift
//  Collaboration
//
//  Created by Akaki Titberidze on 18.05.24.
//

import UIKit

extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getWeatherDataCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCell.reuseIdentifier, for: indexPath) as? WeatherCell else {
            fatalError("Unable to dequeue WeatherCell")
        }
        
        guard let weatherData = viewModel.getWeatherDataDay(at: indexPath.row) else {
            fatalError("Unable to get weather data for index \(indexPath.row)")
        }
        
        guard let icon = weatherData.weather.first?.icon else {
            fatalError("No icon for weather data")
        }
        
        let iconURL = "https://openweathermap.org/img/wn/\(icon).png"
        let temperature = weatherData.main.temp
        let time: String
        
        if indexPath.row == 0 {
            time = "Now"
        } else {
            time = viewModel.convertUnixTo24HR(unixTime: weatherData.dt)
        }
        
        cell.configure(with: iconURL, temperature: "\(Int(temperature.rounded()))°", time: time)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 60, height: 100)
    }
}
