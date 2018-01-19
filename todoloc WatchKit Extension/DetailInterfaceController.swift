//
//  DetailInterfaceController.swift
//  todoloc WatchKit Extension
//
//  Created by Jean-Christophe MELIKIAN on 18/01/2018.
//  Copyright © 2018 Nico. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class DetailInterfaceController: WKInterfaceController {
   
    // -- FIELDS
    @IBOutlet var taskDescription: WKInterfaceLabel!
    
    var list: TodoListModel?
    var task: TaskModel? {
        didSet {
            loadTask()
        }
    }
    
    // -- LIFECYCLE METHODS
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        list = context as? TodoListModel
        
        if let currentTask = list?.currentTask {
            self.task = currentTask
        }
        loadTask()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // -- UI ACTIONS
    @IBAction func onCompleteTouch() {
        // Setting the task completed
        self.list?.completeCurrentTask()
        print("Finished ? \((self.list?.finished)!)")
        if (self.list?.finished)! {
            presentAlert(withTitle: "Bravo !", message: "You just finished the last task !", preferredStyle: WKAlertControllerStyle.alert, actions: [WKAlertAction(title: "Done", style: WKAlertActionStyle.default, handler: {
                self.dismiss()
            })])
        } else {
            // Passing to the next task
            self.task = self.list?.currentTask
        }
    }
    
    @IBAction func onBackTouch() {
        dismiss()
    }
    
    // OTHER METHODS
    
    // Called every time the task field is set
    func loadTask() {
        self.taskDescription.setText(self.task?.name)
    }
}
