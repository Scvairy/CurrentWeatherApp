//
//  Record+CoreDataClass.swift
//  CurrentWeather
//
//  Created by Timur Sharifyanov on 20/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Record)
public class Record: NSManagedObject {

    struct Keys {
        static let date = "dt"
        static let sunrise = "sunrise"
        static let sunset = "sunset"
        static let units = "units"

        static let cityId = "id"
        static let condition = "weather"
        static let conditionId = "id"
    }

    convenience init?(from json: JSON, insertInto context: NSManagedObjectContext) {
        self.init(context: context)

        self.date = Date(timeIntervalSince1970: TimeInterval(json[Keys.date].intValue))
        self.sunrise = Date(timeIntervalSince1970: TimeInterval(json[Keys.sunrise].intValue))
        self.sunset = Date(timeIntervalSince1970: TimeInterval(json[Keys.sunset].intValue))
        // TODO: Push units to userInfo
        units = (context.userInfo[Keys.units] as? Units)?.rawValue ?? 0

        data = WeatherData(from: json, insertInto: context)
        wind = WindData(from: json, insertInto: context)

        let cityRequest = City.fetchRequest() as NSFetchRequest<City>
        let cityId = json[Keys.cityId].int32Value
        cityRequest.predicate = NSPredicate(format: "%K == %d", "id", cityId)

        city = try? context.fetch(cityRequest).first ?? City(from: json, insertInto: context)

        let conditionRequest = WeatherCondition.fetchRequest() as NSFetchRequest<WeatherCondition>
        let conditionId = json[Keys.condition].array?[0][Keys.conditionId].int32Value ?? 0
        conditionRequest.predicate = NSPredicate(format: "%K == %d", "id", conditionId)

        condition = try? context.fetch(conditionRequest).first ?? WeatherCondition(from: json, insertInto: context)
    }

    static func addRecord(from json: JSON, insertInto context: NSManagedObjectContext) -> Record? {
        let timestamp = json[Keys.date].intValue
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))

        let recordRequest = Record.fetchRequest() as NSFetchRequest<Record>
        recordRequest.predicate = NSPredicate(format: "%K == %@", "date", date as NSDate)

        let record = try? context.fetch(recordRequest).first
        guard record == nil else { return record }

        return Record.init(from: json, insertInto: context)
    }

}

enum Units: NSDecimalNumber {
    case unknown = 0
    case metric = 1
    case imperial = 2
}
