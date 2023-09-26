//
//  City+CoreDataProperties.swift
//  
//
//  Created by Lenochka on 7/11/23.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var name: String?

}
