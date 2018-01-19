//
//  TaskModel.swift
//  todoloc WatchKit Extension
//
//  Created by Jean-Christophe MELIKIAN on 20/01/2018.
//  Copyright © 2018 Nico. All rights reserved.
//

import Foundation

public class TaskModel {
    var name: String = ""
    var description: String = ""
    var completed: Bool = false
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, description: String, completed: Bool) {
        self.name = name
        self.description = description
        self.completed = completed
    }
}
