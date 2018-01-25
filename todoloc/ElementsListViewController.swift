//
//  ElementsListViewController.swift
//  todoloc
//
//  Created by Nico on 29/12/2017.
//  Copyright © 2017 Nico. All rights reserved.
//

import UIKit
import CoreLocation

class ElementsListViewController: UIViewController, UITableViewDataSource , UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var navvigationItem: UINavigationItem!
    
    
    @IBOutlet var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var todos: [Todo] = []
    var locationManager: CLLocationManager!

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) in
                if error == nil {
                    if let placemarks = placemarks {
                        for placemark in placemarks {
                            for aTodo in  self.todos {
                                
                                let value: Double = (aTodo.latitude - (placemark.location?.coordinate.latitude)!)*(aTodo.latitude - (placemark.location?.coordinate.latitude)!) + (aTodo.longitude - (placemark.location?.coordinate.longitude)!)*(aTodo.longitude - (placemark.location?.coordinate.longitude)!)
                                if value.squareRoot() < 0.5 {
                                    print("VOUS ETES DANS LA ZONE DE : " + aTodo.address!)
                                }
                            }
                            print("#################")
                            print(placemark.location?.coordinate.latitude)
                            print(placemark.location?.coordinate.longitude)
                            print("#################")
                        }
                    }
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTodo()
        self.tableView.register(UINib(nibName:"ElementListTableViewCell",bundle:nil), forCellReuseIdentifier: "reuseCellIdentifier")
        

        tableView.dataSource = self
        tableView.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            let manager = CLLocationManager()
            manager.delegate = self
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            self.locationManager = manager
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
        self.navigationItem.rightBarButtonItem  = add
        getTodo()
    }
    
    func getTodo(){
        do {
            todos = try context.fetch(Todo.fetchRequest())
            self.tableView.reloadData()
        } catch {
            print("Echec !")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func addButton(){
        self.navigationController?.pushViewController(AddTodoViewController(), animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCellIdentifier", for: indexPath)
        if let accessoryCell = cell as? ElementListTableViewCell {
        
            accessoryCell.label.text = self.todos[indexPath.item].title
            if (self.todos[indexPath.item].tasks?.count)! <= 0 {
                accessoryCell.labelSousTitre.text = "Done"
            }else{
                let aTask: Task = self.todos[indexPath.item].tasks?.allObjects[0] as! Task
                accessoryCell.labelSousTitre.text = aTask.name
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailController.todo = self.todos[indexPath.item]
        
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("delete button tapped")
            let todo = self.todos[indexPath.row]
            self.context.delete(todo)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.getTodo()
        }
        delete.backgroundColor = .red
        
        return [delete]
    }
    

}
