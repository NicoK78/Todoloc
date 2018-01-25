//
//  TaskModel.swift
//  todoloc WatchKit Extension
//
//  Created by Jean-Christophe MELIKIAN on 20/01/2018.
//  Copyright © 2018 Nico. All rights reserved.
//

import Foundation

public class TaskModel: Codable {
    var name: String = ""
    var detail: String = ""
    var finished: Bool = false
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, detail: String, completed: Bool) {
        self.name = name
        self.detail = detail
        self.finished = completed
    }
    
    
}
