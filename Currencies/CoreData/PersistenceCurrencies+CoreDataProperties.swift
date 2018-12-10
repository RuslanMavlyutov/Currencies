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
    @NSManaged public var date: String?
    @NSManaged public var previousDate: String?
    @NSManaged public var previousURL: String?
    @NSManaged public var timeStamp: String?
    @NSManaged public var valute: NSSet?

}

// MARK: Generated accessors for valute
extension PersistenceCurrencies {

    @objc(addValuteObject:)
    @NSManaged public func addToValute(_ value: PersistenceValute)

    @objc(removeValuteObject:)
    @NSManaged public func removeFromValute(_ value: PersistenceValute)

    @objc(addValute:)
    @NSManaged public func addToValute(_ values: NSSet)

    @objc(removeValute:)
    @NSManaged public func removeFromValute(_ values: NSSet)

}
