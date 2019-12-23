//
//  WindData+CoreDataClass.swift
//  CurrentWeather
//
//  Created by Timur Sharifyanov on 20/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(WindData)
public class WindData: NSManagedObject {

    struct Keys {
        static let wind = "wind"

        static let speed = "speed"
        static let degrees = "deg"
    }

    convenience init?(from json: JSON?, insertInto context: NSManagedObjectContext) {
        guard let json = json else { return nil }
        self.init(context: context)

        let wind = json[Keys.wind]

        speed = wind[Keys.speed].doubleValue
        deg = wind[Keys.degrees].int16Value
    }
    
}
