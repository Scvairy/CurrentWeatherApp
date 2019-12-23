//
//  Color+fromDate.swift
//  CurrentWeather
//
//  Created by Timur Sharifyanov on 22/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//

import UIKit

fileprivate typealias Second = Int
fileprivate typealias Hour = Double

fileprivate extension Second {
    init(hours: Hour) {
        self.init(hours * 3600)
    }
}

fileprivate extension Date {
    func daySeconds() -> Second {
        return Second(Calendar.current.component(.hour, from: self) * 3600
        + Calendar.current.component(.minute, from: self) * 60
        + Calendar.current.component(.second, from: self))
    }
}

class WeatherColors {

    static func background(for timeOfDay: TimeOfDay) -> UIColor {
        switch timeOfDay {
        case .sunset, .sunrise:
            return .orange
        case .morning, .noon, .afternoon:
            return UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        case .dawn, .twilight, .evening:
            return UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
        case .night, .midnight:
            return UIColor(red: 54/255, green: 52/255, blue: 163/255, alpha: 1)
        }
    }

    static func label(for timeOfDay: TimeOfDay) -> UIColor {
        switch timeOfDay {
        case .morning, .sunrise, .noon, .afternoon, .sunset:
            return .black
        case .dawn, .twilight, .evening, .night, .midnight:
            return .white
        }
    }

    static func isItDark(for timeOfDay: TimeOfDay) -> Bool {
        switch timeOfDay {
        case .morning, .sunrise, .noon, .afternoon, .sunset:
            return false
        case .dawn, .twilight, .evening, .night, .midnight:
            return true
        }
    }

    enum TimeOfDay {
        case dawn, morning, sunrise, noon, afternoon, sunset, twilight, evening, night, midnight

        init(date: Date, sunrise sunriseDate: Date, sunset sunsetDate: Date) {
            let now = date.daySeconds()
            let sunrise = sunriseDate.daySeconds()
            let sunset = sunsetDate.daySeconds()

            switch now {
            case (sunset - Second(hours: 0.25))..<(sunset + Second(hours: 0.25)):
                self = .sunset
            case (sunrise - Second(hours: 0.25))..<(sunrise + Second(hours: 0.25)):
                self = .sunrise
            case Second(hours: 23)...Second(hours: 24),
                 Second(hours: 0)..<Second(hours: 1):
                self = .midnight
            case Second(hours: 1)..<Second(hours: 5):
                self = .night
            case Second(hours: 5)..<Second(hours: 7):
                self = .dawn
            case Second(hours: 7)..<Second(hours: 10):
                self = .morning
            case Second(hours: 10)..<Second(hours: 14):
                self = .noon
            case Second(hours: 14)..<Second(hours: 18):
                self = .afternoon
            case Second(hours: 18)..<Second(hours: 20):
                self = .evening
            case Second(hours: 20)..<Second(hours: 23):
                self = .twilight
            default:
                self = .noon
            }
        }
    }
}
