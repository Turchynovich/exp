//
//  Currency+CoreDataProperties.swift
//  exp
//
//  Created by Артём Турчинович on 5/22/19.
//  Copyright © 2019 Артём Турчинович. All rights reserved.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var code: String?
    @NSManaged public var name: String?
    @NSManaged public var status: Bool
    @NSManaged public var symbol: String?
    @NSManaged public var payment: NSSet?

}

// MARK: Generated accessors for payment
extension Currency {

    @objc(addPaymentObject:)
    @NSManaged public func addToPayment(_ value: Payment)

    @objc(removePaymentObject:)
    @NSManaged public func removeFromPayment(_ value: Payment)

    @objc(addPayment:)
    @NSManaged public func addToPayment(_ values: NSSet)

    @objc(removePayment:)
    @NSManaged public func removeFromPayment(_ values: NSSet)

}
