//
//  WeatherEntity+CoreDataProperties.swift
//  Salman_Rahman_FE_8878244
//
//  Created by user223067 on 12/11/23.
//
//

import Foundation
import CoreData


extension WeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherEntity> {
        return NSFetchRequest<WeatherEntity>(entityName: "WeatherEntity")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var date: String?
    @NSManaged public var historyId: UUID?
    @NSManaged public var humidity: String?
    @NSManaged public var id: UUID?
    @NSManaged public var originatedFrom: String?
    @NSManaged public var temperature: String?
    @NSManaged public var time: String?
    @NSManaged public var wind: String?

}

extension WeatherEntity : Identifiable {

}
