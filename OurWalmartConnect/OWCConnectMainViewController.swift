//
//  OWCConnectMainViewController.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/30/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class OWCConnectMainView: UIViewController,UISearchBarDelegate, MKMapViewDelegate, MBProgressHUDDelegate,OWCConnectTableViewDataManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var connectSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var searchBar: UISearchBar!
    let reuseID = "walmartPin"
    
    
    var connectDataManager:OWCConnectTableViewDataManager?
    var childVC:OWCConnectTableViewController?
    var mapAnnotations:[MKPointAnnotation] = [MKPointAnnotation]()
    
    var refreshHUD: MBProgressHUD!
    var location: CLLocation? {
        return OWCLocationManager.sharedInstance.userLocation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Loading bar
        refreshHUD = MBProgressHUD(view: view)
        view.addSubview(refreshHUD!)
        refreshHUD?.delegate = self
        
        //Mapping
        self.mapView.delegate = self
        
        
        childVC = self.childViewControllers.first as? OWCConnectTableViewController
        
        //Set Up Data Manager
        let query = PFQuery(className: "walmartLocations")
        query.whereKeyExists("Location")
        let currentLocation = PFGeoPoint(location: OWCLocationManager.sharedInstance.userLocation)
        query.whereKey("Location", nearGeoPoint: currentLocation, withinMiles: 100)
        self.connectDataManager = OWCConnectTableViewDataManager(currentViewController: childVC!
            , query: query)
        self.connectDataManager?.delegate = self
        
        //Segment control initially set to walmart
        self.connectSegmentedControl.selectedSegmentIndex = 0
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if let loc = location {
            centerOnUserLocation(animated: true)
            self.addWalmartLocationToMap()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func segmentControllChanged(sender: AnyObject) {
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        switch self.connectSegmentedControl.selectedSegmentIndex{
        case 0:
            let query = PFQuery(className: "walmartLocations")
            query.whereKey("City", matchesRegex: self.searchBar.text!,modifiers: "i")
            
            let currentLocation = PFGeoPoint(location: OWCLocationManager.sharedInstance.userLocation)
            query.whereKeyExists("Location")
            query.whereKey("Location", nearGeoPoint: currentLocation, withinMiles: 100)
            self.connectDataManager?.loadDataFromQuery(query)
            
        case 1:
            let query = PFUser.query()
            query!.whereKey("Name", matchesRegex: self.searchBar.text!,modifiers: "i")
            query!.whereKey("isAdvisor", equalTo: true)
            self.connectDataManager?.loadDataFromQuery(query!)
        case 2:
            let query = PFUser.query()
            query!.whereKey("Name", matchesRegex: self.searchBar.text!,modifiers: "i"
            )
            query!.whereKey("isAdvisor", equalTo: false)
            self.connectDataManager?.loadDataFromQuery(query!)
        default:
            break
            
        }
    }
    
    //MAPPING
    
    func centerOnUserLocation(animated animated: Bool) {
        if let loc = location {
            mapView.setRegion(MKCoordinateRegion(center: loc.coordinate, span: MKCoordinateSpanMake(0.1, 0.1)), animated: true)
        }
    }
    
    func findMidpointOfMap() -> CLLocation {
        let nePoint = CGPointMake(self.mapView.bounds.origin.x + mapView.bounds.size.width, mapView.bounds.origin.y)
        let swPoint = CGPointMake((self.mapView.bounds.origin.x), (mapView.bounds.origin.y + mapView.bounds.size.height))
        let neCoord = mapView.convertPoint(nePoint, toCoordinateFromView: mapView)
        let swCoord = mapView.convertPoint(swPoint, toCoordinateFromView: mapView)
        let newCoordinate = CLLocationCoordinate2DMake((neCoord.latitude + swCoord.latitude) / 2, (neCoord.longitude + swCoord.longitude) / 2)
        
        return CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isEqual(mapView.userLocation) {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        
        if view == nil {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            view!.canShowCallout = true
            
            view!.image = UIImage(named: "store.png")!
            view!.contentMode = UIViewContentMode.ScaleAspectFit
            
            let detailButton: UIButton = UIButton(type: .DetailDisclosure)
            detailButton.setImage(UIImage(named: "greyArrow")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
            detailButton.addTarget(self, action: "selectWalmartButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            
            view!.rightCalloutAccessoryView = detailButton
        }
        
        view!.annotation = annotation
        return view
    }

    func addWalmartLocationToMap(){
        print("add walmart location func")
        
        print(self.connectDataManager?.tableViewObjects.count)
        self.mapView.removeAnnotations(self.mapAnnotations)
        
        for walmart in (self.connectDataManager?.tableViewObjects)!{
            let annotation = MKPointAnnotation()
            print(walmart.objectForKey("Location"))
            let coordinates = CLLocationCoordinate2DMake(walmart.objectForKey("Location")!.latitude,walmart.objectForKey("Location")!.longitude)
            annotation.title = ((walmart  as! PFObject).objectForKey("City") as! String)
            annotation.subtitle = ((walmart  as! PFObject).objectForKey("Address") as! String)
            annotation.coordinate = coordinates
            self.mapAnnotations.append(annotation)
        }
        self.mapView.addAnnotations(self.mapAnnotations)
    }

    @IBAction func selectWalmartButtonPressed(sender: AnyObject) {
        print("Message")
    }
    
    func loadMapAnnotations() {
        if self.connectSegmentedControl.selectedSegmentIndex == 0 {
            print("Protocol called")
            self.addWalmartLocationToMap()
        }
       
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
