//
//  InterfaceController.swift
//  todoloc WatchKit Extension
//
//  Created by Nico on 28/12/2017.
//  Copyright © 2017 Nico. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class ElementsListInterfaceController: WKInterfaceController {
    
    // -- FIELDS
    
    @IBOutlet var homeTodoListsTable: WKInterfaceTable!
    
    // Optional to simulate
    /*
    let todos: [TodoListModel]? = [
        TodoListModel(title: "Test", latitude: 1.0, longitude: 1.0, address: "2 rue du moulin 93170",
                      tasks: [TaskModel(name: "Tache 1"), TaskModel(name: "Tache débile")]),
        TodoListModel(title: "Loltest", latitude: 1.0, longitude: 1.0, address: "2 rue du moulin 93170",
                      tasks: [TaskModel(name: "lol 1"), TaskModel(name: "lol débile")])
    ]
     */
    var todos: [TodoListModel]? = []

    let jsonEncoder: JSONEncoder = JSONEncoder()
    let jsonDecoder: JSONDecoder = JSONDecoder()

    
    // -- LIFECYCLE METHODS
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        requestTodolists()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        let session = WCSession.default
        session.delegate = self
        session.activate()
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
    func requestTodolists() {
        let session = WCSession.default
        guard session.isReachable else {
            print("WCSession not ready yet")
            return
        }
        let data = "#READY#".data(using: .utf8)
        session.sendMessageData(data!, replyHandler: { (reply) in
            print("Reply: \(reply)")
        }) { (err) in
            print(err)
        }
    }
    
    fileprivate func reloadTodoLists() {
        if let todoLists = self.todos {
            self.homeTodoListsTable.setNumberOfRows(todoLists.count, withRowType: "todoListRow")
            
            for index in 0..<self.homeTodoListsTable.numberOfRows {
                guard let mapController = self.homeTodoListsTable.rowController(at: index) as? TodoListsRowController else {
                    return
                }
                
                mapController.listTitle.setText(todoLists[index].title)
            }
            
        } else {
            self.homeTodoListsTable.setNumberOfRows(0, withRowType: "todosList")
        }
    }

}

// -- EXTENSION: CONNECTIVITY
extension ElementsListInterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        //let json = String(data: messageData, encoding: .utf8) as String!
        do {
            let todoLists = try jsonDecoder.decode([TodoListModel].self, from: messageData)
            
            print("WatchOS IC> Receive todolists> Successfully decoded")
            
            self.todos = todoLists
            reloadTodoLists()
            replyHandler("WatchOS IC> Did receive todolists".data(using: String.Encoding.utf8)!)
            
        } catch {
            print("WatchOS IC> Receive todolists> Failed while decoding todolists")
            replyHandler("WatchOS IC> Receive todolists> Failed while decoding todolists".data(using: String.Encoding.utf8)!)
        }
        
    }
}

