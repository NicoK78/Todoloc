//
//  TodoModel.swift
//  todoloc WatchKit Extension
//
//  Created by Jean-Christophe MELIKIAN on 19/01/2018.
//  Copyright © 2018 Nico. All rights reserved.
//

import Foundation


public class TodoListModel: Codable {
    
    public var title: String = ""
    public var tasks: [TaskModel]? = []
    public var latitude: Double = 0.1
    public var longitude: Double = 0.1
    public var address: String = ""
    
    public var finished: Bool = false
    private var _currentTaskIndex: Int = 0
    public var currentTaskIndex: Int {
        get {
            return self._currentTaskIndex
        }
        set {
            if let tasksList = self.tasks {
                if currentTaskIndex < tasksList.count-1 {
                    _currentTaskIndex = newValue
                }
            }
        }
    }
    public var currentTask: TaskModel? {
        get {
            if let list = tasks {
                return list[self.currentTaskIndex]
            }
            return nil
        }
    }
    
    
    public var completedCount: Int {
        get {
            var count = 0
            for task in self.tasks! {
                count = (task.finished) ? count+1:count+0
            }
            return count
        }
    }
    
    init() {
        
    }
    
    init(title: String, latitude: Double, longitude: Double, address: String, tasks:[TaskModel]?) {
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.tasks = tasks
    }
    
    public func completeCurrentTask() {
        let index = self.currentTaskIndex
        self.tasks![index].finished = true
        
        if self.currentTaskIndex < (self.tasks?.count)!-1 {
            self.currentTaskIndex += 1
        }
        print("task count: \(tasks?.count ?? 0); completed: \(completedCount)")
        self.finished = (completedCount == tasks?.count) ? true : false
    }
    
}

