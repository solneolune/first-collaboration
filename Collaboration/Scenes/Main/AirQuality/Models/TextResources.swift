//
//  TextResources.swift
//  Collaboration
//
//  Created by Luka  Kharatishvili on 18.05.24.
//

import Foundation

struct TextResources {
    struct Standards {
        static let good = "0 to 50: Good"
        static let moderate = "51 to 100: Moderate"
        static let unhealthyForSensitiveGroups = "101 to 150: Unhealthy for Sensitive Groups"
        static let unhealthy = "151 to 200: Unhealthy"
        static let veryUnhealthy = "201 to 300: Very Unhealthy"
        static let hazardous = "301 to 500: Hazardous"
    }

    struct Standards_Desc {
        static let good_desc = "Air quality is considered satisfactory, and air pollution poses little or no risk."

        static let moderate_desc = "Air quality is acceptable; however, there may be a moderate health concern for those who are sensitive to air pollution."

        static let unhealthyForSensitiveGroups_desc = "Members of sensitive groups may experience health effects. The general public is not likely to be affected."

        static let unhealthy_desc = "Everyone may begin to experience health effects; members of sensitive groups may experience more serious health effects."

        static let veryUnhealthy_desc = "Health alert: everyone may experience more serious health effects."

        static let hazardous_desc = "Health warnings of emergency conditions. The entire population is more"

        static let pollutionInfo = "The Air Quality Index (AQI) is a scale used to communicate how polluted the air currently is or how polluted it is forecast to become. Here's how to interpret the AQIUS values based on the United States Environmental Protection Agency (EPA) standards"
    }
}
