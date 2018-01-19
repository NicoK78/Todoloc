//
//  DetailViewController.swift
//  todoloc
//
//  Created by Selom Viadenou on 19/01/2018.
//  Copyright © 2018 Nico. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var todom : TodoModel? = nil
    @IBOutlet var listView: UITableView!
    
    @IBOutlet var labelTitre: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listView.dataSource = self
        
        self.labelTitre.text = self.todom?.titre
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

extension DetailViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.todom?.taches?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = self.todom?.taches![indexPath.item]
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
