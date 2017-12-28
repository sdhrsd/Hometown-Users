                                        




//
//  RegisterUserViewController.swift
//  Assignment5
//
//  Created by Admin on 11/6/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class RegisterUserViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,latitudeAndLongitudeDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    
    var country:Array<String>?
    var state:Array<String>?
    var yearArray:Array<String>?
    var year:String?
    let countryPickerView = UIPickerView()
    let statePickerView = UIPickerView()
    let yearPickerView = UIPickerView()
    var countrySelected:String?
    var stateSelected:String?
    var yearSelected:String?
    let geoCoder = CLGeocoder()
    var activeTextField:UITextField!
    
    /************************** Parameters to Send ****************************************/
    
    var parameters:Parameters = [:]
 
    /************************************ View Did Load Starts Here *************************/
        override func viewDidLoad() {
        super.viewDidLoad()
        nicknameTextField.becomeFirstResponder()
        self.title = "Enter User Informtion"
        countryTextField.inputView = countryPickerView
        countryPickerView.delegate = self
        countryPickerView.tag = 1
        stateTextField.inputView = statePickerView
        statePickerView.delegate = self
        statePickerView.tag = 2
        yearTextField.inputView = yearPickerView
        yearPickerView.delegate = self
        yearPickerView.tag = 3
            
        /************************ to load year*******************************/
        let data:Bundle = Bundle.main
        let yearPlist:String? = data.path(forResource: "Year", ofType: "plist")
        if yearPlist != nil {
            yearArray = (NSArray.init(contentsOfFile: yearPlist!) as! Array)
            yearArray = yearArray?.sorted(by:>)
            yearTextField.text = yearArray?.first
            yearSelected = yearArray!.first
            }
            
        /************************* Requesting the list of countries ***************************/
            
         loadTheCountries()
            
        /************************* Adding a done button when UIPicker pops up *************************/
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        toolbar.barStyle = UIBarStyle.blackTranslucent
        toolbar.tintColor = UIColor.white
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,target: self,action:nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(RegisterUserViewController.donePressed(sender:)))
        toolbar.setItems([flexible,doneButton,flexible], animated: true)
        nicknameTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
        countryTextField.inputAccessoryView = toolbar
        stateTextField.inputAccessoryView = toolbar
        cityTextField.inputAccessoryView = toolbar
        yearTextField.inputAccessoryView = toolbar
        latitudeTextField.inputAccessoryView = toolbar
        longitudeTextField.inputAccessoryView = toolbar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*************************** All functions related to pickerview starts here **************************/

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
        else if pickerView.tag == 2 {
            guard (state != nil) else {
                return 0
            }
            return (state?.count)!
        }
        else if pickerView.tag == 3 {
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
        else if pickerView.tag == 2 {
            guard(state != nil) else {
                return nil
            }
            return state?[row]
        }
        else if pickerView.tag == 3 {
            guard(yearArray != nil) else {
                return nil
            }
            return yearArray?[row]
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            countryTextField.text = country?[row]
            countrySelected = countryTextField.text
            getStatesByCountry(countrySelected: countrySelected!)
        }
        else if pickerView.tag == 2 {
            stateTextField.text = state?[row]
        }
        else if pickerView.tag == 3 {
            yearTextField.text = yearArray?[row]
        }
    }
    /**********************Functions related to pickerview ends here **************************/
    
    /********************* Checking if nickname already exists *********************************/
    @IBAction func checkNickname(_ sender: Any) {
        let nicknameParameter :Parameters = ["name": nicknameTextField.text!]
        Alamofire.request("https://bismarck.sdsu.edu/hometown/nicknameexists", parameters: nicknameParameter)
            .validate()
            .responseString {
                response in
                switch response.result {
                case .success:
                if let utf8Text = response.result.value {
                    print(utf8Text)
                    if(utf8Text == "true") {
                        let alert = UIAlertController(title: "Nickname Already Exists", message: "Enter another nickname", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in self.nicknameTextField.becomeFirstResponder()})
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if(utf8Text == "false"){
                    }
                }
            case .failure(let error):
                print(error) }
        }
    }
    /**************************** Checking Password ********************************/
    @IBAction func passwordTextFieldChanged(_ sender: Any) {
        let password = passwordTextField.text
        if ((password?.count)! < 3) {
            let alert = UIAlertController(title: "Invalid Password", message: "Password length should be greater than two", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in self.passwordTextField.becomeFirstResponder()})
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /****************************** func to get states according to country *****************/
    func getStatesByCountry(countrySelected:String) {
        let countryParameter:Parameters = ["country":countrySelected]
        Alamofire.request("https://bismarck.sdsu.edu/hometown/states",parameters: countryParameter)
            .validate()
            .responseJSON {
                response in
                switch response.result {
                case .success:
                    if let utf8Text = response.result.value {
                        //print(utf8Text)
                        let jsonObject = utf8Text as! Array<String> 
                        self.state = jsonObject
                        self.stateTextField.text = (self.state![0])
                        self.statePickerView.selectRow(0, inComponent: 0, animated: true)
                    }
                case .failure(let error):
                    print(error) }
        }
    }
    
    @IBAction func latitudeChanged(_ sender: Any) {
        if (latitudeTextField.text != "") {
            if let latitude = Double(latitudeTextField.text!) {
                if(latitude < -90 || latitude > 90) {
                    let alert = UIAlertController(title: "Invalid Latitude",message: "Enter latitude between -90 and 90 ", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in self.latitudeTextField.becomeFirstResponder()})
                    alert.addAction(okAction)
                    present(alert, animated: true, completion: nil)
                }
            }
            else {
                let alert = UIAlertController(title: "Invalid Latitude",message: "Enter latitude between -90 and 90 ", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in self.latitudeTextField.becomeFirstResponder()})
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func longitudeChanged(_ sender: Any) {
        if (longitudeTextField.text != "") {
            if let longitude = Double(longitudeTextField.text!) {
                if(longitude < -180 || longitude > 180) {
                    let alert = UIAlertController(title: "Invalid Longitude",message: "Enter longitude between -180 and 180 ", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in self.latitudeTextField.becomeFirstResponder()})
                    alert.addAction(okAction)
                    present(alert, animated: true, completion: nil)
                }
            }
            else {
                let alert = UIAlertController(title: "Invalid Longitude",message: "Enter longitude between -180 and 180 ", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in self.longitudeTextField.becomeFirstResponder()})
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    /***************************** Submit New User Information ***********************************/
    @IBAction func submitButtonPressed(_ sender: Any) {
        if(nicknameTextField.text != "" && passwordTextField.text != "" && countryTextField.text != "" &&  stateTextField.text != "" && cityTextField.text != "" && latitudeTextField.text != "" && longitudeTextField.text != "") {
            parameters = ["nickname":nicknameTextField.text!,"password":passwordTextField.text!,"country":countryTextField.text!,"state":stateTextField.text!,"city":cityTextField.text!,"year":Int(yearTextField.text!)!, "latitude":Double(latitudeTextField.text!)!,"longitude":Double(longitudeTextField.text!)!]
            print(parameters)
            submitData()
        }
        else if(nicknameTextField.text != "" && passwordTextField.text != "" && countryTextField.text != "" &&  stateTextField.text != "" && cityTextField.text != ""){
            let address = cityTextField.text! + " " + stateTextField.text! + " " + countryTextField.text!
            print(address)
            
            forwardGeocoding(address:address ,completion: {success, coordinate in
                if success {
                    let coordinate1 = coordinate
                    let lat = coordinate1?.latitude
                    let lon = coordinate1?.longitude
                    self.parameters = ["nickname":self.nicknameTextField.text!,"password":self.passwordTextField.text!,"country":self.countryTextField.text!,"state":self.stateTextField.text!,"city":self.cityTextField.text!,"year":Int(self.yearTextField.text!)!,"latitude":lat!,"longitude":lon!]
                    print(self.parameters)
                    self.submitData()
                }
                else {
                    self.parameters = ["nickname":self.nicknameTextField.text!,"password":self.passwordTextField.text!,"country":self.countryTextField.text!,"state":self.stateTextField.text!,"city":self.cityTextField.text!,"year":Int(self.yearTextField.text!)!]
                    print(self.parameters)
                    self.submitData()
                }
            })
        }
        else if(nicknameTextField.text == "") {
            let alert = UIAlertController(title: "Enter A Nickname", message: "Enter a nickname", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in self.nicknameTextField.becomeFirstResponder()})
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if(passwordTextField.text == "") {
            let alert = UIAlertController(title: "Enter Password", message: "Enter a password of at least three characters", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in self.passwordTextField.becomeFirstResponder()})
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if(cityTextField.text == "") {
            let alert = UIAlertController(title: "Enter a City", message: "Enter a city", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in self.cityTextField.becomeFirstResponder()})
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func donePressed(sender:UIBarButtonItem) {
        view.endEditing(true)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PickLocationViewController {
            destination.delegate = self
            destination.country = countrySelected
            if(latitudeTextField.text != "" && longitudeTextField.text != "")
            {
            destination.latitude = Double(latitudeTextField.text!)
            destination.longitude = Double(longitudeTextField.text!)
            }
            else if (cityTextField.text != "") {
                destination.country = String(countryTextField.text!)
                destination.state = String(stateTextField.text!)
                destination.city = cityTextField.text!
            }
        }
    }
    /**************** latitude and longitude delegate ********************/
    func userPickedLocation(latitude: Double?, longitude: Double?) {
        if let latitude = latitude ,let longitude = longitude {
        latitudeTextField.text = "\(latitude)"
        longitudeTextField.text = "\(longitude)"
        }
    }
    func submitData() {
        Alamofire.request("https://bismarck.sdsu.edu/hometown/adduser", method: .post, parameters: parameters,encoding: JSONEncoding.default)
            .validate()
            .responseString {
                response in
                switch response.result {
                case .success:
                    if let utf8Text = response.result.value {
                        print(utf8Text)
                        self.clearData()
                        let alert = UIAlertController(title: "Registration Successful",message: "Your registration was successful ", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler:nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error) }
        }
    }
    func clearData() {
        nicknameTextField.text = ""
        passwordTextField.text = ""
        loadTheCountries()
        yearTextField.text = yearArray?.first
        cityTextField.text = ""
        latitudeTextField.text = ""
        longitudeTextField.text = ""
    }
    func loadTheCountries() {
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
                        if(self.country != nil) {
                            self.countryTextField.text = (self.country![0])
                            self.countrySelected = self.countryTextField.text
                            self.getStatesByCountry(countrySelected: self.countrySelected!)
                        }
                    }
                case .failure(let error):
                    print(error) }
        }
    }
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
