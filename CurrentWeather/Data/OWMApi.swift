//
//  OWMApi.swift
//  CurrentWeather
//
//  Created by Timur Sharifyanov on 21/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

class OWMApi {
    let apiKey: String
    let apiRoot = "https://api.openweathermap.org/data/2.5"
    let units = "metric"
    let lang: String

    init(apiKey: String, lang: String? = nil) {
        self.apiKey = apiKey
        self.lang = lang ?? NSLocale.preferredLanguages.first!
    }

    public func getCurrentWeather(for location: CLLocation, completion: @escaping (JSON?, NetworkError?) -> ()) {
        let (lat, lon) = (location.coordinate.latitude, location.coordinate.longitude)
        var url = URLComponents(string: "\(apiRoot)/weather")
        url?.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "apiKey", value: "\(apiKey)"),
            URLQueryItem(name: "units", value: "\(units)"),
            URLQueryItem(name: "lang", value: "\(lang)"),
        ]

        Network.loadJSON(url: url!.string!, completion: completion)
    }
}
