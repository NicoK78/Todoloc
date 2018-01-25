//
//  DetailViewController.swift
//  todoloc
//
//  Created by Selom Viadenou on 19/01/2018.
//  Copyright © 2018 Nico. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var todo:Todo? = nil
    @IBOutlet var listView: UITableView!
    
    @IBOutlet var labelTitre: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listView.dataSource = self
        self.listView.delegate = self
        self.labelTitre.text = self.todo?.title
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController:UITableViewDataSource ,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (self.todo?.taches?.count)!
        return (self.todo?.tasks?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
//        cell.textLabel?.text = self.todo?.taches![indexPath.item]
        let task: Task = self.todo?.tasks?.allObjects[indexPath.item] as! Task
        cell.textLabel?.text = task.name
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in

//            self.todo?.taches?.remove(at: index.item)
            let mutableSet: NSMutableSet = self.todo?.tasks as! NSMutableSet
            mutableSet.remove(self.todo?.tasks?.allObjects[index.item])
            self.todo?.tasks = mutableSet

            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.listView.reloadData()
        }
        delete.backgroundColor = .red
        
        return [delete]
    }
    
    
}

