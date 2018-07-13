//
//  Search+CoreDataProperties.swift
//  
//
//  Created by Thomas Rademaker on 7/13/18.
//
//

import Foundation
import CoreData


extension Search {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Search> {
        return NSFetchRequest<Search>(entityName: "Search")
    }

    @NSManaged public var keyword: String?
    @NSManaged public var timeStamp: NSDate?

}
