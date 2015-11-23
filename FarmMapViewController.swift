//
//  FarmMapViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 11/13/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit
import MapKit

class FarmMapViewController: UIViewController, MKMapViewDelegate {
    
    struct Constants {
        static let Brunswick:CLLocation = CLLocation(latitude: 43.9108, longitude: -69.9631)
        static let MapRadius:CLLocationDistance = 1000
    }
    
    var farms = [LocalFarm]()
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .Satellite
            mapView.delegate = self
        }
    }
    
    //allows for toggle between map view and list view of search results
    var mapViewController: UIViewController?
    var listViewController: UIViewController?
    
    private var activeViewController: UIViewController? {
        didSet {
            removeIdleViewController(oldValue)
            updateActiveViewControllerInParentView()
        }
    }
    
    private func removeIdleViewController(idleViewController: UIViewController?) {
        if let inactiveView = idleViewController {
            inactiveView.willMoveToParentViewController(nil)
            inactiveView.view.removeFromSuperview()
            inactiveView.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewControllerInParentView() {
        if let activeVC = activeViewController {
            addChildViewController(activeVC)
            activeVC.view.frame = self.view.bounds
            self.view.addSubview(activeVC.view)
            activeVC.didMoveToParentViewController(self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if mapViewController != nil {
            let mapViewInstance = MKMapView()
            mapViewInstance.mapType = .Satellite
            mapViewInstance.frame = self.view.frame
            mapViewController!.view.addSubview(mapViewInstance)
        }
        centerMaponLoc(Constants.Brunswick)
        mapView.delegate = self
        let brunswickPin = LocalFarm(title: "Brunwick", locationName: "Downtown Brunswick", coordinate: CLLocationCoordinate2D(latitude: Constants.Brunswick.coordinate.latitude, longitude: Constants.Brunswick.coordinate.longitude))
        mapView.addAnnotation(brunswickPin)
        
        if farms.count > 0 {
            for individual in farms {
                mapView.addAnnotation(individual)
            }
        }
        
        let dropPinGesture = UILongPressGestureRecognizer(target: self, action: Selector("dropPin:"))
        mapView.addGestureRecognizer(dropPinGesture)
        // Do any additional setup after loading the view.
    }
    
    func dropPin(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.Began {
            let coordinate = mapView.convertPoint(gesture.locationInView(mapView), toCoordinateFromView: mapView)
            let farmPin = LocalFarm(title: "User Dropped Pin", locationName: "", coordinate: coordinate)
            mapView.addAnnotation(farmPin)
        }
    }
    
    func centerMaponLoc(location: CLLocation) {
        let coordinates = MKCoordinateRegionMakeWithDistance(location.coordinate, Constants.MapRadius * 2, Constants.MapRadius * 2)
        mapView.setRegion(coordinates, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? LocalFarm {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedPin = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView{
                dequeuedPin.annotation = annotation
                view = dequeuedPin
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        for pins in views {
            let endFrame = pins.frame
            pins.frame = CGRectOffset(endFrame, 0, -500)
            UIView.animateWithDuration(0.5, animations: {() in
                pins.frame = endFrame
                }, completion: {(bool) in
                    UIView.animateWithDuration(0.05, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:{() in
                        pins.transform = CGAffineTransformMakeScale(1.0, 0.6)
                        }, completion: {(Bool) in
                            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:{() in
                                pins.transform = CGAffineTransformIdentity
                                }, completion: nil)
                    })
                }
            )
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
