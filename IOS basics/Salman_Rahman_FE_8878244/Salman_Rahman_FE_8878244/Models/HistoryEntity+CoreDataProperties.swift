//
//  HistoryEntity+CoreDataProperties.swift
//  Salman_Rahman_FE_8878244
//
//  Created by user223067 on 12/3/23.
//
//

import Foundation
import CoreData


extension HistoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryEntity> {
        return NSFetchRequest<HistoryEntity>(entityName: "HistoryEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var type: String?

}

extension HistoryEntity : Identifiable {

}
