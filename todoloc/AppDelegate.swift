//
//  AppDelegate.swift
//  todoloc
//
//  Created by Nico on 28/12/2017.
//  Copyright © 2017 Nico. All rights reserved.
//

import UIKit
import CoreData
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let jsonEncoder: JSONEncoder = JSONEncoder()
    let jsonDecoder: JSONDecoder = JSONDecoder()
    var todos: [Todo] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        //self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        window.rootViewController = UINavigationController(rootViewController: ElementsListViewController())
        window.makeKeyAndVisible()
        self.window = window
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        } else {
            print("WCVSession is not supported")
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "todoloc")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchTasksLists() -> Data? {
        do {
            let context = persistentContainer.viewContext
            let todolistsEntities: [Todo] = try context.fetch(Todo.fetchRequest())
            var todolists: [TodoListModel] = []
            for list in todolistsEntities {
                let listm = TodoListModel(entity:list)
                todolists.append(listm)
            }
            return try self.jsonEncoder.encode(todolists)
        } catch {
            print("iOS> Failed sending to watchapp")
        }
        return nil
    }
    
    func sendTasksLists() {
        if let json = fetchTasksLists() {
            WCSession.default.sendMessageData(json, replyHandler: { (data) in
                // Handle replies
                print("iOS> Send todolists> Got reply: \(data)")
            }, errorHandler: { (err) in
                // Handle errors
                print("iOS> Send todolists> Got error: \(err)")
            })
        } else {
            print("Could not fetch the todo lists")
        }
    }
    
    func updateTask(uuid: String) -> Bool {
        let context = persistentContainer.viewContext
        do {
            todos = try context.fetch(Todo.fetchRequest())
        } catch {
            print("Echec !")
            return false
        }
        for todo: Todo in todos {
            for task in todo.tasks! {
                let t = task as! Task
                let isEqual = (t.id?.uuidString == uuid)
                if isEqual {
                    t.finished = true
                }
            }
        }
        saveContext()
        return true
    }
}

extension AppDelegate: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        if let msg = String(data: messageData, encoding: .utf8) as String! {
            if msg == "#READY#" {
                if let todolists = fetchTasksLists() {
                    replyHandler(todolists)
                } else {
                    print("Error while fetching task lists")
                    replyHandler("Error while fetching task lists".data(using: String.Encoding.utf8)!)
                }
                
            } else {
                print("iOS> Receive task's uuid> Successfully red uuid(\(msg)")
                let result = updateTask(uuid: msg)
                let str = "Setting the task status to complete is a \(result ? "success": "failure")".data(using: String.Encoding.utf8)
                if result {
                    replyHandler(str!)
                } else {
                    print("iOS> Receive task's uuid> Failed while reading uuid")
                    replyHandler("iOS> Receive task's uuid> Failed while reading uuid".data(using: String.Encoding.utf8)!)
                }
            }
        } else {
            print("iOS> Unknown request")
            replyHandler("iOS> Unknown request".data(using: String.Encoding.utf8)!)
        }
    }
}
