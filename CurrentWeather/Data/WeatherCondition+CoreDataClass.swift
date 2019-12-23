//
//  WeatherCondition+CoreDataClass.swift
//  CurrentWeather
//
//  Created by Timur Sharifyanov on 20/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(WeatherCondition)
public class WeatherCondition: NSManagedObject {

    struct Keys {
        static let weather = "weather"

        static let main = "main"
        static let id = "id"
        static let iconName = "icon"
        static let desc = "description"
    }

    convenience init?(from json: JSON?, insertInto context: NSManagedObjectContext) {
        guard let weather = json?[Keys.weather].array?[0] else { return nil }
        self.init(context: context)

        main = weather[Keys.main].stringValue
        desc = weather[Keys.desc].stringValue
        id = weather[Keys.id].int32Value
        icon = weather[Keys.iconName].stringValue
    }

}
