//
//  Task+CoreDataProperties.swift
//  todoloc
//
//  Created by Nico on 25/01/2018.
//  Copyright © 2018 Nico. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var detail: String?
    @NSManaged public var finished: Bool
    @NSManaged public var id: UUID?

}
