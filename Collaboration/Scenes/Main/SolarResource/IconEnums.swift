//
//  IconEnums.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.
//

import Foundation

enum Icon: String {
    case directIrradiance, globalIrradiance, tiltAtLatitude
    
    var systemName: String {
        switch self {
        case .directIrradiance: return "sun.max.fill"
        case .globalIrradiance: return "sun.haze.fill"
        case .tiltAtLatitude: return "arrow.up.and.down.circle.fill"
        }
    }
}
