//
//  ElementsListViewController.swift
//  todoloc
//
//  Created by Nico on 29/12/2017.
//  Copyright © 2017 Nico. All rights reserved.
//

import UIKit

class ElementsListViewController: UIViewController {
    
    @IBOutlet var navvigationItem: UINavigationItem!
    

    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButton(_:)))
        self.navigationItem.rightBarButtonItem  = addButton
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func addButton(_ sender:AnyObject){
        self.navigationController?.pushViewController(AddTodoViewController(), animated: true)
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
