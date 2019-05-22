//
//  Payment+CoreDataProperties.swift
//  exp
//
//  Created by Артём Турчинович on 5/22/19.
//  Copyright © 2019 Артём Турчинович. All rights reserved.
//
//

import Foundation
import CoreData


extension Payment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Payment> {
        return NSFetchRequest<Payment>(entityName: "Payment")
    }

    @NSManaged public var count: Double
    @NSManaged public var date: NSDate?
    @NSManaged public var category: Category?
    @NSManaged public var currency: Currency?

}
