//
//  PickLocationViewController.swift
//  Assignment5
//
//  Created by Admin on 11/6/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol latitudeAndLongitudeDelegate {
    func userPickedLocation(latitude:Double?,longitude:Double?)
}

class PickLocationViewController: UIViewController,MKMapViewDelegate ,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var country:String?
    var state:String?
    var city:String?
    var latitude:Double?
    var longitude:Double?
    var delegate: latitudeAndLongitudeDelegate?
    let geoCoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Your Location"
        mapView.delegate = self
        tapYourLocation()
        displayLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tapYourLocation() {
        let tapLocation = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        tapLocation.numberOfTapsRequired = 1
        tapLocation.delegate = self
        mapView.addGestureRecognizer(tapLocation)
    }
    
    @objc func dropPin(sender:UITapGestureRecognizer) {
        removePin()
        print("Pin was dropped")
        let pointTouched = sender.location(in: mapView)
        let coordinateTouched = mapView.convert(pointTouched, toCoordinateFrom: mapView)
        print(coordinateTouched)
        let annotation = DropPinOnLocation(coordinate: coordinateTouched, identifier: "dropPin",title:"Your Location")
        mapView.addAnnotation(annotation)
        delegate?.userPickedLocation(latitude: coordinateTouched.latitude, longitude: coordinateTouched.longitude)
    }
    func removePin() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    }
    /************* Function to display current user's location when lat and long given *************/
    func displayLocation() {
        if let latitudePassed = latitude,let longitudePassed = longitude {
        let coordinatesPassed = CLLocationCoordinate2DMake(latitudePassed, longitudePassed)
            let annotation = DropPinOnLocation(coordinate: coordinatesPassed, identifier: "YourLocation",title:"Your Location")
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(60,60)
        let coordinateRegion = MKCoordinateRegionMake(coordinatesPassed, span)
        mapView.setRegion(coordinateRegion, animated: true)
        }
        /******************** location if city state and country entered ***************/
        else if let cityPassed = city,let statePassed = state,let countryPassed = country {
            let address = cityPassed + " " + statePassed + " " + countryPassed
            print(address)
            forwardGeocoding(address:address ,completion: {success, coordinate in
            if success {
                let annotation = DropPinOnLocation(coordinate: coordinate!, identifier: "YourLocation",title:"Selected Location")
                self.mapView.addAnnotation(annotation)
                let span = MKCoordinateSpanMake(60,60)
                let coordinateRegion = MKCoordinateRegionMake(coordinate!, span)
                self.mapView.setRegion(coordinateRegion, animated: true)
                self.delegate?.userPickedLocation(latitude: coordinate?.latitude, longitude: coordinate?.longitude)

            }
            else {
                return
            }
        })
    }
}
    /*************************** Function to geocode an address *******************************/
    func forwardGeocoding (address: String, completion: @escaping (Bool, CLLocationCoordinate2D?) -> () ) {
        geoCoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                completion(false,nil)
                return
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                completion(true, coordinates)
            }
        })
    }
    
}
