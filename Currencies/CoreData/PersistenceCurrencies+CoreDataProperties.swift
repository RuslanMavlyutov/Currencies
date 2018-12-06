//
//  PersistenceCurrencies+CoreDataProperties.swift
//  
//
//  Created by Ruslan Mavlyutov on 07/12/2018.
//
//

import Foundation
import CoreData


extension PersistenceCurrencies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistenceCurrencies> {
        return NSFetchRequest<PersistenceCurrencies>(entityName: "PersistenceCurrencies")
    }

    @NSManaged public var coins: String?
    @NSManaged public var coinsDescription: String?

}
