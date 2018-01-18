//
//  ElementsListViewController.swift
//  todoloc
//
//  Created by Nico on 29/12/2017.
//  Copyright © 2017 Nico. All rights reserved.
//

import UIKit

class ElementsListViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet var navvigationItem: UINavigationItem!
    
    
    @IBOutlet var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var todos: [Todo] = []
    //var todo:Todo? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.todo = Todo()
        getTodo()
        print("---------")
        print(todos)
        //print(dataSource)
        self.tableView.register(UINib(nibName:"ElementListTableViewCell",bundle:nil), forCellReuseIdentifier: "reuseCellIdentifier")
        
        //        for i in 0...1{
        //            var todo: Todo = Todo()
        //            todo.nom = "Test \(i)"
        //            todo.sousTitre += ["Sous Titre plein d'info \(i)"]
        //            dataSource.append(todo)
        //        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
        self.navigationItem.rightBarButtonItem  = add
        getTodo()
        print("---------")
        print(todos)
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
            accessoryCell.label.text = self.todos[indexPath.item].titre
            accessoryCell.labelSousTitre.text = self.todos[indexPath.item].taches?[0]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("delete button tapped")
            self.todos.remove(at: indexPath.item)
            self.tableView.reloadData()
        }
        delete.backgroundColor = .red
        
        return [delete]
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
