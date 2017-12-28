//
//  ListOfUsersViewController.swift
//  Assignment5
//
//  Created by Admin on 11/10/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit
import Alamofire

class ListOfUsersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var listOfUsersTable: UITableView!
    var searchCountry:String?
    var sendUser = [Users]()
    var tables = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listOfUsersTable.dataSource = self
        listOfUsersTable.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(tables.count)
        return tables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if let cell = tableView.dequeueReusableCell(withIdentifier: "UsersListViewCell") as? UsersListViewCell {
            let user = tables[indexPath.row]
            cell.updateCell(users: user)
            return cell
         } else {
            return UsersListViewCell()
        }
    }
    let id = "UserDetailView"
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //let row = indexPath.row
        //print("My row is \(row)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //print("Triggered")
        if segue.identifier == id {
            //print("Triggered Again")

        if let destination = segue.destination as? UserDetailViewController,
            let indexPath = self.listOfUsersTable.indexPathForSelectedRow {
            let user = tables[indexPath.row]
            destination.nickname = user.nickname
            destination.country = user.country
            destination.state = user.state
            destination.city = user.city
            destination.year = "\(user.year)"
            }
        }
       
        else {
            //print("Nottriggered again")
        }
    }
    
}
