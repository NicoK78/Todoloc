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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTodo()
        self.tableView.register(UINib(nibName:"ElementListTableViewCell",bundle:nil), forCellReuseIdentifier: "reuseCellIdentifier")
        

        tableView.dataSource = self
        tableView.delegate = self
        
        
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
            accessoryCell.label.text = self.todos[indexPath.item].titre
            accessoryCell.labelSousTitre.text = self.todos[indexPath.item].taches?[0]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = TodoModel()
        todo.titre = self.todos[indexPath.item].titre
        todo.taches = self.todos[indexPath.item].taches // A refaire
        
        let detailController = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailController.todom = todo
        
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
