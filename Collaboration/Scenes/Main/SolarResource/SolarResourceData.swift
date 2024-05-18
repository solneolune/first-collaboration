//
//  SolarResourceData.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.
//

import Foundation

var solarResourceInfoCards: [CustomCard] = [
    CustomCard(icon: .directIrradiance, title: "Average Direct Normal Irradiance", description: "This data provides monthly average and annual average daily total solar resource averaged over surface cells of 0.1 degrees in both latitude and longitude, or about 10 km in size. The values returned are kWh/m2/day (kilowatt hours per square meter per day). The insolation values represent the resource available to concentrating systems that track the sun throughout the day."),
    CustomCard(icon: .globalIrradiance, title: "Average Global Horizontal Irradiance", description: "This data provides monthly average and annual average daily total solar resource averaged over surface cells of 0.1 degrees in both latitude and longitude, or about 10 km in size. The values returned are kWh/m2/day (kilowatt hours per square meter per day). The insolation values represent the global horizontal resource - the geometric sum of direct normal and diffuse irradiance components, representing total energy available on a planar surface."),
    CustomCard(icon: .tiltAtLatitude, title: "Average Tilt at Latitude", description: "This data provides monthly average and annual average daily total solar resource averaged over surface cells of 0.1 degrees in both latitude and longitude, or about 10 km in size. The values returned are kWh/m2/day (kilowatt hours per square meter per day). The insolation values represent the resource available to fixed flat plate system tilted towards the equator at an angle equal to the latitude.")
]
