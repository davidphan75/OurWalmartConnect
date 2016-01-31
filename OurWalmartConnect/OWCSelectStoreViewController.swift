//
//  OWCSelectStoreViewController.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/30/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI

protocol userDidSelectWalmart {
    func userDidSelectWalmart(walmart: PFObject)
}

class OWCSelectStoreViewController: UIViewController, MKMapViewDelegate, MBProgressHUDDelegate  {
    @IBOutlet weak var mapView: MKMapView!
    
    var refreshHUD: MBProgressHUD!
    var location: CLLocation? {
        return OWCLocationManager.sharedInstance.userLocation
    }
    var del: userDidSelectWalmart?
    var reuseID = "walmartPin"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        refreshHUD = MBProgressHUD(view: view)
        view.addSubview(refreshHUD!)
        refreshHUD?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let loc = location {
            centerOnUserLocation(animated: true)
            findWalmartNearLocation(loc)
        } else {
            let alert = UIAlertController(title: "No location data!", message: "It seems that you did opt out from using the location Walmart Connect location. Please go to Preferences in your iPhone and set the Our Walmart Connect location usage preference to \"When in use\".", preferredStyle: UIAlertControllerStyle.Alert)

            presentViewController(alert, animated: true, completion: nil)
        }
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
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
    
    func centerOnUserLocation(animated animated: Bool) {
        if let loc = location {
            mapView.setRegion(MKCoordinateRegion(center: loc.coordinate, span: MKCoordinateSpanMake(0.1, 0.1)), animated: true)
        }
    }
    
    func findWalmartNearLocation(location: CLLocation) {
        refreshHUD?.show(true)
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "walmart"
        let span = MKCoordinateSpanMake(0.1, 0.1)
        request.region = MKCoordinateRegionMake(location.coordinate, span)
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response: MKLocalSearchResponse?, error: NSError?) -> Void in
            if (error == nil) {
                let locationsArray = response!.mapItems
                
                for location in locationsArray {
                    
                    //get more field
                    let address = location.placemark.addressDictionary as NSDictionary!
                    let city = address.objectForKey("City") as! String
                    let state = address.objectForKey("State") as! String

                    
                    
                    let walmart = OWCWalmartLocation(city: city, address: ABCreateStringWithAddressDictionary(location.placemark.addressDictionary!, false),state:state, location: location.placemark.location!)
                    self.mapView.addAnnotation(walmart)
                }
                
                self.refreshHUD?.hide(true)
            }
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
    

    @IBAction func redoSearchButtonPressed(sender: AnyObject) {
        mapView.removeAnnotations(mapView.annotations)
        findWalmartNearLocation(findMidpointOfMap())
    }
    
    @IBAction func centerOnUserLocationButtonPressed(sender: AnyObject) {
        centerOnUserLocation(animated: true)
    }
    
    @IBAction func selectWalmartButtonPressed(sender: AnyObject) {
        if mapView.selectedAnnotations.isEmpty {
            let alertView = UIAlertView(title: "Oops!", message: "Make sure you select a Walmart!", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            
        } else {
            let selectedWalmart = mapView.selectedAnnotations.first as! OWCWalmartLocation
            askUserToConfirm((selectedWalmart.address))
        }
    }
    
    func retrieveWalmart() {
        refreshHUD?.show(true)
        
        var WalmartOnParse = PFObject(className: "walmartLocations")
        
        if mapView.selectedAnnotations.isEmpty {
            let alertView = UIAlertView(title: "Oops!", message: "Make sure you select a Walmart location!", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            
        } else {
            let selectedWalmart = mapView.selectedAnnotations.first as! OWCWalmartLocation
            let WalmartQuery = PFQuery(className: "walmartLocation")
            WalmartQuery.whereKey("Address", equalTo: selectedWalmart.subtitle!)
            
            WalmartQuery.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                if (object == nil) {
                
                    WalmartOnParse.setObject(1, forKey: "numberOfUsers")
                    WalmartOnParse.setObject(selectedWalmart.city!, forKey: "City")
                      WalmartOnParse.setObject(selectedWalmart.state!, forKey: "State")
                    WalmartOnParse.setObject(PFGeoPoint(latitude: selectedWalmart.location.coordinate.latitude, longitude: selectedWalmart.location.coordinate.longitude), forKey: "Location")
                    WalmartOnParse.setObject(selectedWalmart.subtitle!, forKey: "Address")
                    WalmartOnParse.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                        if success == false || error != nil {
                            print("The walmart could not be saved in the database!")
                        }
                    })
                } else {
                    if let number:Int = object?.objectForKey("numberOfUsers") as? Int{
                        object?.setObject(number + 1, forKey: "numberOfUsers")
                    }else{
                        object?.setObject(1, forKey: "numberOfUsers")
                    }
                    
                    object?.setObject(PFGeoPoint(latitude: selectedWalmart.location.coordinate.latitude, longitude: selectedWalmart.location.coordinate.longitude), forKey: "Location")
                    
                    object?.saveInBackground()
                    WalmartOnParse = object!
                }
                
                self.refreshHUD?.hide(true)
                
                self.del?.userDidSelectWalmart(WalmartOnParse)
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
    func askUserToConfirm(walmartName: String) {
        let actionSheet = UIAlertController(title: "Is this your Walmart?", message: walmartName, preferredStyle: UIAlertControllerStyle.Alert)
        
        let option1 = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (actionSheet: UIAlertAction) -> Void in
            self.retrieveWalmart()
        }
        
        let option2 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        actionSheet.addAction(option1)
        actionSheet.addAction(option2)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
