//
//  City+CoreDataClass.swift
//  CurrentWeather
//
//  Created by Timur Sharifyanov on 20/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(City)
public class City: NSManagedObject {

    struct Keys {
        static let city = "city"
        static let id = "id"
        static let name = "name"
        static let coord = "coord"
        static let lat = "lat"
        static let lon = "lon"
    }

    convenience init?(from json: JSON?, insertInto context: NSManagedObjectContext) {
        guard let json = json else { return nil }
        self.init(context: context)

        lat = json[Keys.coord][Keys.lat].doubleValue
        lon = json[Keys.coord][Keys.lon].doubleValue
        id = json[Keys.id].int32Value
        name = json[Keys.name].stringValue
    }
    
}
