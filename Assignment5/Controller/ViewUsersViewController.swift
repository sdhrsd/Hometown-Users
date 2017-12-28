//
//  ViewUsersViewController.swift
//  Assignment5
//
//  Created by Admin on 11/6/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit
import Alamofire

class ViewUsersViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var countryTextFieldView: UITextField!
    @IBOutlet weak var yearTextFieldView: UITextField!
    @IBOutlet weak var country1TextFieldView: CustomTextField!
    
    let countryPickerView1 = UIPickerView()
    let yearPickerView1 = UIPickerView()
    let country1PickerView1 = UIPickerView()
    
    var country:Array<String>?
    var yearArray:Array<String>?
    var year:String?
    var countrySelected:String?
    var stateSelected:String?
    var yearSelected:String?
    var country1Selected:String?
    
    var tables = [Users]()
    var whoSent = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "View Users"
        countryTextFieldView.inputView = countryPickerView1
        countryPickerView1.delegate = self
        countryPickerView1.tag = 1
        yearTextFieldView.inputView = yearPickerView1
        yearPickerView1.delegate = self
        yearPickerView1.tag = 2
        country1TextFieldView.inputView = country1PickerView1
        country1PickerView1.delegate = self
        country1PickerView1.tag = 3
        
        /************************ to load year*******************************/
        let data:Bundle = Bundle.main
        let yearPlist:String? = data.path(forResource: "Year", ofType: "plist")
        if yearPlist != nil {
            yearArray = (NSArray.init(contentsOfFile: yearPlist!) as! Array)
            yearArray = yearArray?.sorted(by:>)
            yearTextFieldView.text = yearArray?.first
            yearSelected = yearArray!.first
        }
        
        /************************* Requesting the list of countries ***************************/
        Alamofire.request("https://bismarck.sdsu.edu/hometown/countries")
            .validate()
            .responseJSON {
                response in
                switch response.result {
                case .success:
                    if let utf8Text = response.result.value {
                        //print(utf8Text)
                        let jsonObject = utf8Text as! Array<String> // NSArray
                        self.country = jsonObject
                        self.countryTextFieldView.text = (self.country![0])
                        self.countrySelected = self.countryTextFieldView.text
                        self.country1TextFieldView.text = (self.country![0])
                        self.country1Selected = self.countryTextFieldView.text
                    }
                case .failure(let error):
                    print(error) }
        }
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        toolbar.barStyle = UIBarStyle.blackTranslucent
        toolbar.tintColor = UIColor.white
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ViewUsersViewController.donePressed(sender:)))
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,target: self,action:nil)
        toolbar.setItems([flexible,doneButton,flexible], animated: true)
        countryTextFieldView.inputAccessoryView = toolbar
        country1TextFieldView.inputAccessoryView = toolbar
        yearTextFieldView.inputAccessoryView = toolbar
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard (country != nil) else {
            return 0
        }
        if pickerView.tag == 1 {
            return (country?.count)!
        }
        else if pickerView.tag == 3 {
            guard (country != nil) else {
                return 0
            }
            return (country?.count)!
        }
        else if pickerView.tag == 2 {
            guard (yearArray != nil) else {
                return 0
            }
            return (yearArray?.count)!
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard(country != nil) else {
            return nil
        }
        if pickerView.tag == 1 {
            return country?[row]
        }
        else if pickerView.tag == 3 {
            guard(country != nil) else {
                return nil
            }
            return country?[row]
        }
        else if pickerView.tag == 2 {
            guard(yearArray != nil) else {
                return nil
            }
            return yearArray?[row]
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            countryTextFieldView.text = country?[row]
            countrySelected = countryTextFieldView.text
            
        }
        else if pickerView.tag == 3 {
            country1TextFieldView.text = country?[row]
            country1Selected = country1TextFieldView.text
            
        }
        else if pickerView.tag == 2 {
            yearTextFieldView.text = yearArray?[row]
            yearSelected = yearArray?[row]
        }
    }
    /**********************Functions related to pickerview ends here **************************/
    
    @objc func donePressed(sender:UIBarButtonItem) {
        view.endEditing(true)
    }
    let id1 = "ShowUsersListView"
    let id2 = "ShowUsersMapView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == id1 {
        if let destination = segue.destination as? ListOfUsersViewController{
            destination.tables = tables
            
        }
        }
        else if segue.identifier == id2 {
            print("Map Triggered")
            if let destination = segue.destination as? ShowUsersMapViewController{
                destination.whoSent = whoSent
                destination.countrySelected = countrySelected!
                destination.yearSelected = yearSelected!
                destination.country1Selected = country1Selected!
        }
    }
}
    
    /********************* List All the Users *********************************************/
    @IBAction func listViewAllUsers(_ sender: Any) {
        tables = [Users]()
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
                            let year = dict["year"] as! Int
                            let id = dict["id"] as! Int
                            let latitude = dict["latitude"] as! Double
                            let timestamp = dict["time-stamp"] as! String
                            let country = dict["country"] as! String
                            
                            let tables1 = Users(nickname: nickname, city: city, longitude: longitude, state: state, year: year, id: id, latitude: latitude, timestamp: timestamp, country: country)
                                self.tables = self.tables + [tables1]
                                //print(nickname,country,city,year)
                        }
                        print("No. of Entries in table")
                        print(self.tables.count)
                       self.performSegue(withIdentifier: "ShowUsersListView", sender: self)
                    }
                case .failure(let error):
                    print(error) }
        }
    }
    /************************** List Users by Country And Year ********************************/
    @IBAction func listViewCountryAndYear(_ sender: Any) {
        tables = [Users]()
        let parameters:Parameters = ["country":countrySelected!]
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
                            let id = dict["id"] as! Int
                            let latitude = dict["latitude"] as! Double
                            let timestamp = dict["time-stamp"] as! String
                            let country = dict["country"] as! String
                            
                            if(year == Int(self.yearSelected!)){
                                let tables1 = Users(nickname: nickname, city: city, longitude: longitude, state: state, year: year, id: id, latitude: latitude, timestamp: timestamp, country: country)
                                self.tables = self.tables + [tables1]
                                //print(nickname,country,city,year)
                            }
                        }
                        print("No. of Entries in table")
                        print(self.tables.count)
                        self.performSegue(withIdentifier: "ShowUsersListView", sender: self)
                    }
                case .failure(let error):
                    print(error) }
        }
    }
    /********************************** List Users by Country *********************************/
    @IBAction func listViewCountry(_ sender: Any) {
        tables = [Users]()
        let parameters:Parameters = ["country":country1Selected!]
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
                            let id = dict["id"] as! Int
                            let latitude = dict["latitude"] as! Double
                            let timestamp = dict["time-stamp"] as! String
                            let country = dict["country"] as! String
                            
                            let tables1 = Users(nickname: nickname, city: city, longitude: longitude, state: state, year: year, id: id, latitude: latitude, timestamp: timestamp, country: country)
                                self.tables = self.tables + [tables1]
                                //print(nickname,country,city,year)
                        }
                        print("No. of Entries in table")
                        print(self.tables.count)
                        self.performSegue(withIdentifier: "ShowUsersListView", sender: self)
                    }
                case .failure(let error):
                    print(error) }
        }
    }
    
    @IBAction func mapViewAllUsers(_ sender: Any) {
        whoSent = "MapAll"
         self.performSegue(withIdentifier: "ShowUsersMapView", sender: self)
   }
    
    @IBAction func mapViewCountryAndYear(_ sender: Any) {
        whoSent = "MapCountryAndYear"
        self.performSegue(withIdentifier: "ShowUsersMapView", sender: self)
    }
    
    @IBAction func mapViewCountry(_ sender: Any) {
        whoSent = "MapByCountry"
        self.performSegue(withIdentifier: "ShowUsersMapView", sender: self)
    }
}
