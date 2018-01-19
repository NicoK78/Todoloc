//
//  TodoModel.swift
//  todoloc WatchKit Extension
//
//  Created by Jean-Christophe MELIKIAN on 19/01/2018.
//  Copyright © 2018 Nico. All rights reserved.
//

import Foundation


public class TodoListModel {
    public var titre: String = ""
    public var tasks: [TaskModel]? = []
    
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
                count = (task.completed) ? count+1:count+0
            }
            return count
        }
    }
    
    init(titre: String, tasks:[TaskModel]?) {
        self.titre = titre
        self.tasks = tasks
    }
    
    public func completeCurrentTask() {
        let index = self.currentTaskIndex
        self.tasks![index].completed = true
        
        if self.currentTaskIndex < (self.tasks?.count)!-1 {
            self.currentTaskIndex += 1
        }
        print("task count: \(tasks?.count); completed: \(completedCount)")
        self.finished = (completedCount == tasks?.count) ? true : false
    }
    
}

