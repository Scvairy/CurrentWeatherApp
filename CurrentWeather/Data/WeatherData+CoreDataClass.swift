//
//  WeatherData+CoreDataClass.swift
//  CurrentWeather
//
//  Created by Timur Sharifyanov on 20/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(WeatherData)
public class WeatherData: NSManagedObject {

    struct Keys {
        static let main = "main"

        static let temp = "temp"
        static let pressure = "pressure"
        static let humidity = "humidity"
    }

    convenience init?(from json: JSON?, insertInto context: NSManagedObjectContext) {
        guard let json = json else { return nil }
        self.init(context: context)

        let main = json[Keys.main]

        temp = main[Keys.temp].doubleValue
        pressure = main[Keys.pressure].doubleValue
        temp = main[Keys.temp].doubleValue
    }

}
