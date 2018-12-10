//
//  PersistenceValute+CoreDataProperties.swift
//  
//
//  Created by Ruslan Mavlyutov on 07/12/2018.
//
//

import Foundation
import CoreData


extension PersistenceValute {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistenceValute> {
        return NSFetchRequest<PersistenceValute>(entityName: "PersistenceValute")
    }

    @NSManaged public var coinName: String?
    @NSManaged public var currencies: PersistenceCurrencies?
    @NSManaged public var descriptionValute: PersistenceCurrencyDescription?

}
