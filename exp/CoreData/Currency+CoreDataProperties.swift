//
//  Currency+CoreDataProperties.swift
//  exp
//
//  Created by Артём Турчинович on 5/5/19.
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

}
