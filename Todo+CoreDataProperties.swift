//
//  Todo+CoreDataProperties.swift
//  todoloc
//
//  Created by Selom Viadenou on 18/01/2018.
//  Copyright © 2018 Nico. All rights reserved.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var titre: String?
    @NSManaged public var taches: [String]?

}
