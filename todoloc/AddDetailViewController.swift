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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.todom?.titre)
        print(self.todom?.taches)
        //self.navigationItem.title = self.todo?.nom
        // Do any additional setup after loading the view.
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchAdresse))
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(rechercheDone))
        self.navigationItem.rightBarButtonItems = [search,done]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func searchAdresse () {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    @objc func rechercheDone(){
        let elementListView = ElementsListViewController(nibName: "ElementsListViewController", bundle: nil)
        //elementListView.todo = self.todo
        addTodo()
        self.navigationController?.popToRootViewController(animated: true)
        //self.navigationController?.pushViewController(elementListView, animated: true)
        
    }
    
    func addTodo(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let todo = Todo(context: context)
        
        todo.titre = self.todom?.titre
        todo.taches = self.todom?.taches
        
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
        /*localSearchRequest = MKLocalSearchRequest()
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
         self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
         }*/
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
