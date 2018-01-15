//
//  AddDetailViewController.swift
//  todoloc
//
//  Created by Selom Viadenou on 13/01/2018.
//  Copyright © 2018 Nico. All rights reserved.
//

import UIKit

class AddDetailViewController: UIViewController {
    var todo : Todo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.todo?.nom
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
