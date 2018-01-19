//
//  InterfaceController.swift
//  todoloc WatchKit Extension
//
//  Created by Nico on 28/12/2017.
//  Copyright © 2017 Nico. All rights reserved.
//

import WatchKit
import Foundation

class ElementsListInterfaceController: WKInterfaceController {
    
    // -- FIELDS
    
    @IBOutlet var homeTodoListsTable: WKInterfaceTable!
    
    // Optional to simulate
    let todos: [TodoListModel]? = [
        TodoListModel(titre: "Test", tasks: [TaskModel(name: "Tache 1"), TaskModel(name: "Tache débile")]),
        TodoListModel(titre: "Loltest", tasks: [TaskModel(name: "lol 1"), TaskModel(name: "lol débile")])
    ]

    
    // -- LIFECYCLE METHODS
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        reloadTodoLists()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        if let todoLists = self.todos {
            let list = todoLists[rowIndex]
            if let taches = list.tasks {
                if taches.count > 0 {
                    if list.completedCount == list.tasks?.count {
                        presentAlert(withTitle: "All done !", message: "This tasks list is already completed ! Well done !", preferredStyle: WKAlertControllerStyle.alert, actions: [WKAlertAction(title: "Back", style: WKAlertActionStyle.cancel, handler: {
                            return
                        })])
                    }
                    presentController(withName: "detailTodoList", context: list)
                }
            }
        }
    }
    
    // -- OTHER METHODS
    
    fileprivate func reloadTodoLists() {
        if let todoLists = self.todos {
            self.homeTodoListsTable.setNumberOfRows(todoLists.count, withRowType: "todoListRow")
            
            for index in 0..<self.homeTodoListsTable.numberOfRows {
                guard let mapController = self.homeTodoListsTable.rowController(at: index) as? TodoListsRowController else {
                    return
                }
                
                mapController.listTitle.setText(todoLists[index].titre)
            }
            
        } else {
            self.homeTodoListsTable.setNumberOfRows(0, withRowType: "todosList")
        }
    }

}
