//
//  NewsEntity+CoreDataProperties.swift
//  Salman_Rahman_FE_8878244
//
//  Created by user223067 on 12/3/23.
//
//

import Foundation
import CoreData


extension NewsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsEntity> {
        return NSFetchRequest<NewsEntity>(entityName: "NewsEntity")
    }

    @NSManaged public var searchedCity: String?
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var source: String?
    @NSManaged public var newsDescription: String?
    @NSManaged public var historyId: UUID?
    @NSManaged public var originatedFrom: String?
    @NSManaged public var id: UUID?

}

extension NewsEntity : Identifiable {

}
