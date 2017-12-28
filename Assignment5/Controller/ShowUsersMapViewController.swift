//
//  ShowUsersMapViewController.swift
//  Assignment5
//
//  Created by Admin on 11/10/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class ShowUsersMapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var usersOnMap = [Users]()
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var allAddress = Array<String>()
    var whoSent = ""
    var countrySelected = ""
    var yearSelected = ""
    var country1Selected = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
        if(whoSent == "MapAll") {
            showAllUsersOnMap()
            
        }
        else if(whoSent == "MapCountryAndYear") {
            showAllUsersByCountryAndYearOnMap()
    }
        else if(whoSent == "MapByCountry"){
            showAllUsersByCountryOnMap()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
  
    func showAllUsersOnMap() {
        var nickname1:[String] = []
        var address1:[String] = []
        removePin()
        Alamofire.request("https://bismarck.sdsu.edu/hometown/users")
            .validate()
            .responseJSON {
                response in
                switch response.result {
                case .success:
                    if let JSON = response.result.value {
                        let jsonObject = JSON as! NSArray
                        //print("JSON: \(jsonObject)")
                        for dict in jsonObject as! [[String:AnyObject]] {
                            let nickname = dict["nickname"] as! String
                            let city = dict["city"] as! String
                            let longitude = dict["longitude"] as! Double
                            let state = dict["state"] as! String
                            let latitude = dict["latitude"] as! Double
                            let country = dict["country"] as! String
                            
                            if(latitude == 0.0 && longitude == 0.0){
                                let address = city + " " + state + " " + country
                                address1 = address1 + [address]
                                let nickname2 = nickname
                                nickname1 = nickname1 + [nickname2]
                                /*self.forwardGeocoding(address: address,completion: {success, coordinate in
                                    if success {
                                        print(coordinate!)
                                        let annotation = DropPinOnLocation(coordinate: coordinate!, identifier: nickname,title:nickname)
                                        self.mapView.addAnnotation(annotation)
                                    }
                                    else {
                                        print("Could Not Geocode")
                                    }
                                }) */
                            }
                            else {
                                
                                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                let annotation = DropPinOnLocation(coordinate: coordinate, identifier: "",title:nickname)
                                self.mapView.addAnnotation(annotation)
                            }
                        }
                        self.geoCode(addresses: address1, nicknames:nickname1) { results in
                            //print("Got back \(results.count) results")
                            //print("The number of annotations is")
                            //print(self.mapView.annotations.count)
                            //print(count)
                            //print(count1)
            
                        }
                            //print("The number of annotations is")
                            //print(self.mapView.annotations.count)
                            //print(count)
                        
                        
                    }
                case .failure(let error):
                    print(error) }
        }
    }
    
    func showAllUsersByCountryAndYearOnMap() {
        var address1:[String] = []
        var nickname1:[String] = []
        let parameters:Parameters = ["country":countrySelected]
        removePin()
        Alamofire.request("https://bismarck.sdsu.edu/hometown/users",parameters:parameters)
            .validate()
            .responseJSON {
                response in
                switch response.result {
                case .success:
                    if let JSON = response.result.value {
                        let jsonObject = JSON as! NSArray
                        //print("JSON: \(jsonObject)")
                        for dict in jsonObject as! [[String:AnyObject]] {
                            let nickname = dict["nickname"] as! String
                            let city = dict["city"] as! String
                            let longitude = dict["longitude"] as! Double
                            let state = dict["state"] as! String
                            let year = dict["year"] as! Int
                            let latitude = dict["latitude"] as! Double
                            let country = dict["country"] as! String
                            
                            if(year == Int(self.yearSelected)){
                            if(latitude == 0.0 && longitude == 0.0){
                                let address = city + " " + state + " " + country
                                address1 = address1 + [address]
                                let nickname2 = nickname
                                nickname1 = nickname1 + [nickname2]
                            }
                            else {
                                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                let annotation = DropPinOnLocation(coordinate: coordinate, identifier: nickname,title:nickname)
                                self.mapView.addAnnotation(annotation)
                            }
                        }
                            
                    }
                        self.geoCode(addresses: address1, nicknames: nickname1) { results in
                            print("Got back \(results.count) results")
                            }
                }
                case .failure(let error):
                    print(error) }
        }
        
    }
    
    func  showAllUsersByCountryOnMap() {
        var nickname1:[String] = []
        var address1:[String] = []
        let parameters:Parameters = ["country":country1Selected]
        removePin()
        Alamofire.request("https://bismarck.sdsu.edu/hometown/users",parameters:parameters)
            .validate()
            .responseJSON {
                response in
                switch response.result {
                case .success:
                    if let JSON = response.result.value {
                        let jsonObject = JSON as! NSArray
                        //print("JSON: \(jsonObject)")
                        for dict in jsonObject as! [[String:AnyObject]] {
                            let nickname = dict["nickname"] as! String
                            let city = dict["city"] as! String
                            let longitude = dict["longitude"] as! Double
                            let state = dict["state"] as! String
                            let latitude = dict["latitude"] as! Double
                            let country = dict["country"] as! String
                            
                                if(latitude == 0.0 && longitude == 0.0){
                                    let address = city + " " + state + " " + country
                                    address1 = address1 + [address]
                                    let nickname2 = nickname
                                    nickname1 = nickname1 + [nickname2]
                                }
                                else {
                                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                    let annotation = DropPinOnLocation(coordinate: coordinate, identifier: nickname,title:nickname)
                                    self.mapView.addAnnotation(annotation)
                                }
                        }
                        self.geoCode(addresses: address1, nicknames: nickname1) { results in
                            print("Got back \(results.count) results")
                            }
                    }
                case .failure(let error):
                    print(error) }
        }
    }

    
    /*func forwardGeocoding (address: String, completion: @escaping (Bool, CLLocationCoordinate2D?) -> () ) {
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
    } */
    func removePin() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    }
    /********************* To geocode an address *****************************************/
    func geoCode(addresses: [String],nicknames:[String] ,results: [CLPlacemark] = [], completion: @escaping ([CLPlacemark]) -> Void ) {
     guard let address = addresses.first else {
     completion(results)
     return
     }
     
     geoCoder.geocodeAddressString(address) { placemarks, error in
     var updatedResults = results
     
     if let placemark = placemarks?.first {
     updatedResults.append(placemark)
     let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
        let annotation = DropPinOnLocation(coordinate: coordinates, identifier: nicknames.first!, title: nicknames.first!)
     self.mapView.addAnnotation(annotation)
     }
     
     let remainingAddresses = Array(addresses[1..<addresses.count])
        let remainingNicknames = Array(nicknames[1..<nicknames.count])
     
        self.geoCode(addresses: remainingAddresses,nicknames:remainingNicknames, results: updatedResults, completion: completion)
     }
     }

}

