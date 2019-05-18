//
//  Image+CoreDataClass.swift
//  exp
//
//  Created by Артём Турчинович on 4/27/19.
//  Copyright © 2019 Артём Турчинович. All rights reserved.
//
//

import Foundation
import CoreData


public class Image: NSManagedObject {
    convenience init() {
        // Описание сущности
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Image"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
