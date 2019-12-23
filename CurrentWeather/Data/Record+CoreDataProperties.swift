//
//  Record+CoreDataProperties.swift
//  CurrentWeather
//
//  Created by Timur Sharifyanov on 22/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var date: Date?
    @NSManaged public var units: NSDecimalNumber?
    @NSManaged public var sunset: Date?
    @NSManaged public var sunrise: Date?
    @NSManaged public var city: City?
    @NSManaged public var condition: WeatherCondition?
    @NSManaged public var data: WeatherData?
    @NSManaged public var wind: WindData?

}
