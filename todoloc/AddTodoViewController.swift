//
//  AddTodoViewController.swift
//  todoloc
//
//  Created by Selom Viadenou on 12/01/2018.
//  Copyright © 2018 Nico. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddTodoViewController: UIViewController , CLLocationManagerDelegate {
    var todo : Todo? = nil
    
    var locationManager:CLLocationManager!
    var initialLocation:CLLocation!
    
    let regionRadius: CLLocationDistance = 1000
    
    @IBOutlet weak var changeTitreTextField: UITextField?
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var textFieldSearch: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        todo = Todo()
        // Do any additional setup after loading the view.
        let nextButton = UIBarButtonItem(title: "Passer", style: .plain, target: self, action: #selector(nextEtape(_:)))
        self.navigationItem.rightBarButtonItem  = nextButton
        //self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func changeTitre(_ sender: Any, forEvent event: UIEvent) {
        if(self.changeTitreTextField?.text != ""){
            self.navigationItem.rightBarButtonItem?.isEnabled = true;
            self.navigationItem.title = self.changeTitreTextField?.text
            self.todo?.nom = (self.changeTitreTextField?.text)!
        }
        if(self.changeTitreTextField?.text == nil){
            self.navigationItem.rightBarButtonItem?.isEnabled = false;
            self.navigationItem.title = nil
        }
    }
    
    
    @IBAction func changeTitreV2(_ sender: Any) {
        if(self.changeTitreTextField?.text == nil){
            self.navigationItem.rightBarButtonItem?.isEnabled = false;
            self.navigationItem.title = nil
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        determineMyCurrentLocation()
    }
    
    @objc func nextEtape(_ sender:AnyObject){
        let AddDetailController = AddDetailViewController(nibName: "AddDetailViewController", bundle: nil)
        AddDetailController.todo = self.todo
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        self.navigationItem.backBarButtonItem = backItem
        
        self.navigationController?.pushViewController(AddDetailController, animated: true)
    }

    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
         //
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        let coordinateUser = MKCoordinateRegionMakeWithDistance(userLocation.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateUser, animated: true)
        manager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
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
