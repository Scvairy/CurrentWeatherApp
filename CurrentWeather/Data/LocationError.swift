//
//  LocationError.swift
//  CurrentWeather
//
//  Created by Timur Sharifyanov on 23/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//

import Foundation

enum LocationError: Error, Describable {
    case noLocationError

    public func getText() -> String {
        switch self {
        case .noLocationError:
            return "Can't get location".localized()
        }
    }
}
