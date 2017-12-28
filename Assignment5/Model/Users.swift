//
//  Users.swift
//  Assignment5
//
//  Created by Admin on 11/10/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import Foundation

struct Users {
    private(set) public var nickname:String
    private(set) public var city:String
    private(set) public var longitude:Double
    private(set) public var state:String
    private(set) public var year:Int
    private(set) public var id:Int
    private(set) public var latitude:Double
    private(set) public var timestamp:String
    private(set) public var country:String
    init(nickname:String,city:String,longitude:Double,state:String,year:Int,id:Int,latitude:Double,timestamp:String,country:String){
        self.nickname = nickname
        self.city = city
        self.longitude = longitude
        self.state = state
        self.year = year
        self.id = id
        self.latitude = latitude
        self.timestamp = timestamp
        self.country = country
    }
}
