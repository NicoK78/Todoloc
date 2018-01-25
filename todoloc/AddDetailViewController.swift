//
//  AddDetailViewController.swift
//  todoloc
//
//  Created by Selom Viadenou on 13/01/2018.
//  Copyright © 2018 Nico. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AddDetailViewController: UIViewController, UISearchBarDelegate {

    var todom : TodoModel? = nil
    

    @IBOutlet var mapView: MKMapView!
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var resultSearchController:UISearchController? = nil
    
    @IBOutlet var resultView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.todom?.titre)
        print(self.todom?.taches)
        //self.navigationItem.title = self.todo?.nom
        // Do any additional setup after loading the view.
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchAdresse))
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(rechercheDone))
        
//        let searchBar = resultSearchController!.searchBar
//        searchBar.sizeToFit()
//        searchBar.placeholder = "Search for places"
//        navigationItem.titleView = resultSearchController?.searchBar
//        
//        resultSearchController?.hidesNavigationBarDuringPresentation = false
//        resultSearchController?.dimsBackgroundDuringPresentation = true
//        definesPresentationContext = true
        
        self.navigationItem.rightBarButtonItems = [search,done]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func searchAdresse () {
//        let locationSearchTable = self.storyboard!.instantiateViewController(withIdentifier: "LocationSearchTableViewController") as! AddDetailViewController
//        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
//        resultSearchController?.searchResultsUpdater = locationSearchTable as! UISearchResultsUpdating
        resultView.isHidden = false
        
        searchController = UISearchController(searchResultsController: resultSearchController)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    @objc func rechercheDone(){
        let elementListView = ElementsListViewController(nibName: "ElementsListViewController", bundle: nil)
        //elementListView.todo = self.todo
        resultView.isHidden = true
        addTodo()
        self.navigationController?.popToRootViewController(animated: true)
        //self.navigationController?.pushViewController(elementListView, animated: true)
        
    }
    
    func addTodo(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let todo = Todo(context: context)
        
        todo.title = self.todom?.titre
        todo.address = pointAnnotation.description
        todo.longitude = pointAnnotation.coordinate.longitude
        todo.latitude = pointAnnotation.coordinate.latitude
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let myContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Todo", in: context)
        let aTask = NSManagedObject(entity: entity!, insertInto: context)
        
        let mutable = NSMutableSet()
//        var aTask = NSEntityDescription.insertNewObject(forEntityName: "test", into: Task().managedObjectContext!)
        for str in (self.todom?.taches)! {
            print("###### IN FOR #######")
//            let aTask: Task? = nil
            print(str)
            aTask.setValue(str, forKeyPath: "name")
            aTask.value(forKeyPath: "name")
            aTask.setValue(false, forKey: "finished")
            aTask.setValue("My Details", forKey: "detail")
//            aTask.value(forKey: "name") = str
            print("good")
//            aTask.value(forKey: "finished") = false
//            aTask.value(forKey: "detail") = "My Details"
//            aTask.name = str
            print("finish")
//            print(aTask.name)
//            aTask.finished = false
//            aTask.detail = "Details"
            
            mutable.add(aTask)
        }
        todo.tasks = mutable
//        todo.tasks = self.todom?.taches
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //searchBar.resignFirstResponder()
        //dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //3
            print(localSearchResponse?.description)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //1
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
         localSearchRequest.naturalLanguageQuery = searchBar.text
         localSearch = MKLocalSearch(request: localSearchRequest)
         localSearch.start { (localSearchResponse, error) -> Void in
         
         if localSearchResponse == nil{
             let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
             alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
             self.present(alertController, animated: true, completion: nil)
             return
             }
             //3
             self.pointAnnotation = MKPointAnnotation()
             self.pointAnnotation.title = searchBar.text
             self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
             self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
             self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            
            let span = MKCoordinateSpanMake(0.015, 0.015)
            let location = CLLocationCoordinate2D(latitude: self.pointAnnotation.coordinate.latitude, longitude: self.pointAnnotation.coordinate.longitude)
            let region = MKCoordinateRegion(center: location, span: span)
            
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            self.mapView.setRegion(region, animated: true)
         }
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
