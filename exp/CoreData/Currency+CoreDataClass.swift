//
//  Currency+CoreDataClass.swift
//  exp
//
//  Created by Артём Турчинович on 5/5/19.
//  Copyright © 2019 Артём Турчинович. All rights reserved.
//
//

import Foundation
import CoreData

public class Currency: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Currency"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
