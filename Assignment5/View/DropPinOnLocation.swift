//
//  DropPinOnLocation.swift
//  Assignment5
//
//  Created by Admin on 11/9/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit
import MapKit

class DropPinOnLocation: NSObject, MKAnnotation {
    
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D,identifier: String,title:String) {
        self.coordinate = coordinate
        self.identifier = identifier
        self.title = title
        super.init()
    }
}
