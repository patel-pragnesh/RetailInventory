//
//  AdjustStockLevels+CoreDataProperties.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/21/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AdjustStockLevels {

    @NSManaged var adjustId: NSNumber?
    @NSManaged var count: NSNumber?
    @NSManaged var dateTimestamp: NSNumber?
    @NSManaged var merchantID: String?
    @NSManaged var needsUpdate: NSNumber?
    @NSManaged var inventoryList: InventoryList?

}
