//
//  WeatherCondition+CoreDataProperties.swift
//  CurrentWeather
//
//  Created by Timur Sharifyanov on 20/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherCondition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherCondition> {
        return NSFetchRequest<WeatherCondition>(entityName: "WeatherCondition")
    }

    @NSManaged public var id: Int32
    @NSManaged public var main: String?
    @NSManaged public var desc: String?
    @NSManaged public var icon: String?
    @NSManaged public var records: NSSet?

}

// MARK: Generated accessors for records
extension WeatherCondition {

    @objc(addRecordsObject:)
    @NSManaged public func addToRecords(_ value: Record)

    @objc(removeRecordsObject:)
    @NSManaged public func removeFromRecords(_ value: Record)

    @objc(addRecords:)
    @NSManaged public func addToRecords(_ values: NSSet)

    @objc(removeRecords:)
    @NSManaged public func removeFromRecords(_ values: NSSet)

}
