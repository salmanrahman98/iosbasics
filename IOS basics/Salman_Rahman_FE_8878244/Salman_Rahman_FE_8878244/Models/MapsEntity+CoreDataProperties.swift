//
//  MapsEntity+CoreDataProperties.swift
//  Salman_Rahman_FE_8878244
//
//  Created by user223067 on 12/3/23.
//
//

import Foundation
import CoreData


extension MapsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MapsEntity> {
        return NSFetchRequest<MapsEntity>(entityName: "MapsEntity")
    }

    @NSManaged public var startPoint: String?
    @NSManaged public var endPoint: String?
    @NSManaged public var modeOfTravel: String?
    @NSManaged public var distanceTravelled: String?
    @NSManaged public var historyId: UUID?
    @NSManaged public var originatedFrom: String?
    @NSManaged public var id: UUID?

}

extension MapsEntity : Identifiable {

}
