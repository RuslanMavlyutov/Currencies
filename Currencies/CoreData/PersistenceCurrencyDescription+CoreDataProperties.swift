//
//  PersistenceCurrencyDescription+CoreDataProperties.swift
//  
//
//  Created by Ruslan Mavlyutov on 07/12/2018.
//
//

import Foundation
import CoreData


extension PersistenceCurrencyDescription {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistenceCurrencyDescription> {
        return NSFetchRequest<PersistenceCurrencyDescription>(entityName: "PersistenceCurrencyDescription")
    }

    @NSManaged public var charCode: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var nominal: Int16
    @NSManaged public var numCode: String?
    @NSManaged public var previous: Float
    @NSManaged public var value: Float
    @NSManaged public var coins: PersistenceValute?

}
