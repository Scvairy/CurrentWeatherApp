//
//  WindData+CoreDataProperties.swift
//  CurrentWeather
//
//  Created by Timur Sharifyanov on 20/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//
//

import Foundation
import CoreData


extension WindData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WindData> {
        return NSFetchRequest<WindData>(entityName: "WindData")
    }

    @NSManaged public var speed: Double
    @NSManaged public var deg: Int16
    @NSManaged public var record: Record?

}
