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
        static let Seattle:CLLocation = CLLocation(latitude: 47.606163, longitude: -122.299805)
        static let MapRadius:CLLocationDistance = 1000
    }
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .Satellite
            mapView.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMaponLoc(Constants.Seattle)
        mapView.delegate = self
        let seattlePin = LocalFarm(title: "Seattle", locationName: "Downtown Seattle", coordinate: CLLocationCoordinate2D(latitude: Constants.Seattle.coordinate.latitude, longitude: Constants.Seattle.coordinate.longitude))
        mapView.addAnnotation(seattlePin)
        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
