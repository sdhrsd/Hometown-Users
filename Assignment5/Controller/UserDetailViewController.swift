//
//  UserDetailViewController.swift
//  Assignment5
//
//  Created by Admin on 11/10/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var nicknameOfUser: UILabel!
    @IBOutlet weak var countryofUser: UILabel!
    @IBOutlet weak var stateOfUser: UILabel!
    @IBOutlet weak var cityOfUser: UILabel!
    @IBOutlet weak var yearOfUser: UILabel!
    
    var nickname:String?
    var country:String?
    var state:String?
    var city:String?
    var year:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameOfUser.text = nickname
        countryofUser.text = country
        stateOfUser.text = state
        cityOfUser.text = city
        yearOfUser.text = year
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    }
