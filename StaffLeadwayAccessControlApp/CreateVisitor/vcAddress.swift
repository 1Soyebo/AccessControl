//
//  vcCreateVisitor.swift
//  StaffLeadwayAccessControlApp
//
//  Created by MacUser on 9/4/19.
//  Copyright © 2019 MacUser. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class vcAddress: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    

    var statePicker:UIPickerView!
    var CityPicker:UIPickerView!
    
    var allStates = [State]()
    var listStates:Any = [] as Any
    
    var allCities = [] as AnyObject
    var listCities:Any = [] as Any
    var manyCities = [City]()
    
    var CodeState:String = ""
    var idState:Int = 0
    var idCity:Int = 0
    
    var Firstname:String = ""
    var LastName:String = ""
    var Email:String = ""
    var PhoneNumber:String = ""

    @IBOutlet weak var txtAddress1: UITextField!
    @IBOutlet weak var txtVisitorCompany: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnNext: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNext.layer.cornerRadius = 8.0
        btnNext.clipsToBounds = true
        img.alpha = 0.8
        self.title = "Register Visitor"
        hideKeyboardWhenTappedAround()
        img.layer.cornerRadius = 8.0
        img.clipsToBounds = true
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 240))
        statePicker=UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 240))
        statePicker.dataSource=self;
        statePicker.delegate=self;
        statePicker.tag=1;
        inputView.addSubview(statePicker)
        txtState.inputView=inputView;
        
        let inputView1 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        CityPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 240))
        CityPicker.dataSource=self;
        CityPicker.delegate=self;
        CityPicker.tag=2;
        inputView1.addSubview(CityPicker)
        txtCity.inputView=inputView1;

        let d = self.listStates as! Array<[String: Any]>
        
        for item in d {
            let stCode: String = item["stateCode"] as! String
            let stName:String = item["stateName"] as! String
            let stID:Int = item["states_id"] as! Int
            //print(amt)
            let st = State(stateCode: stCode, stateName: stName, stateID: stID)
            allStates.append(st)
            //print(boosk[0].Title as Any)
            // print(item)
        }

        
        

        // Do any additional setup after loading the view.
    }

    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func btnCreateAppointment(_ sender: Any) {
        
        
        if(txtState.text?.isEmpty)!{
            SVProgressHUD.showError(withStatus: "State is Required")
        }
        else if(txtCity.text?.isEmpty)!{
            SVProgressHUD.showError(withStatus: "City is Required")
        }
        else if (txtAddress1.text?.isEmpty)!{
            SVProgressHUD.showError(withStatus: "Address1 is Required")
        }else if(txtVisitorCompany.text?.isEmpty)!{
            SVProgressHUD.showError(withStatus: "Visitor Compnay is Required")
        }
        else
        {
            
            
            SVProgressHUD.show()
            let todosEndpoint: String = "http://Dynamics.somee.com/api/Visitor/Create/10004"
            
            /*let newTodo: [String: Any] = ["SupplierName": "a test", "SupAddress": "a test"]*/
            
            let param:Parameters = ["FirstName":Firstname, "Surname":LastName, "Email":Email, "PhoneNumber":PhoneNumber, "Address1":"\(txtAddress1.text!)", "StateID":"\(idState)", "CityID":"\(idCity)", "VisitorCompany":"\(txtVisitorCompany.text!)"]
            Alamofire.request(todosEndpoint, method: .post, parameters: param,
                              encoding: JSONEncoding.default)
                .responseJSON { response in
                    guard response.result.error == nil else {
                        // got an error in getting the data, need to handle it
                        print("error calling POST on /todos/1")
                        print(response.result.error!)
                        SVProgressHUD.showError(withStatus: "Network Error")
                        return
                    }
                    // make sure we got some JSON since that's what we expect
                    guard let json = response.result.value as? [String: Any] else {
                        print("didn't get todo object as JSON from API")
                        if let error = response.result.error {
                            print("Error: \(error)")
                        }
                        return
                    }
                    
                    
                    // get and print the title
                    print(json)
                    let success = json["Status"] as! Bool
                    let message = json["message"] as! String
                    //let success = 1
                    if(success == true)
                    {
                        SVProgressHUD.showInfo(withStatus: message)
                        let pushtoCreateAppointment = vcCreateAppointment(nibName:"vcCreateAppointment", bundle:nil)

                        pushtoCreateAppointment.VistorID = json["VisitorID"] as! Int
                        pushtoCreateAppointment.VisitorName = json["VisitorName"] as! String
                        SVProgressHUD.dismiss()
                        self.navigationController?.pushViewController(pushtoCreateAppointment, animated: true)
                        
                    }
            }
        }
        
    }
        
    
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView.tag == 1
            {
                return allStates.count
            }
            else if pickerView.tag == 2
            {
                return manyCities.count
            }
            else
            {
                return 0
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            
            if pickerView.tag == 1
            {
                return allStates[row].StateName
            }
            else if pickerView.tag == 2
            {
                if manyCities[row].CityName == nil {
                    return "Pick A City"
                }
                return manyCities[row].CityName
            }
            else
            {
                return "Nothing"
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
        {
            self.view.endEditing(true)
            if pickerView.tag == 1
            {
                txtState.text = allStates[row].StateName
                self.CodeState = self.allStates[row].StateCode!
                self.idState = self.allStates[row].StateID!
                self.manyCities = []
                let todoEndpoint: String = "http://Dynamics.somee.com/api/GetListOfCities/\(CodeState)"
                Alamofire.request(todoEndpoint)
                    .responseJSON { response in
                        // check for errors
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling GET on /todos/1")
                            print(response.result.error!)
                            return
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let json = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                            }
                            return
                        }
                        
                        let status = json["Status"] as! Bool
                        //print(json)
                        if(status)
                        {
                            
                            self.allCities = json["Cities"] as AnyObject
                            print(self.allCities)
                            self.listCities = self.allCities
                            let d = self.listCities as! Array<[String: Any]>
                            
                            for item in d
                            {
                                let ctID:Int = item["city_id"] as! Int
                                let ctName:String = item["cityName"] as! String
                                
                                //print(amt)
                                let ceetee = City(CityID: ctID, CityName: ctName);
                                self.manyCities.append(ceetee)
                                
                                
                            }
                            
                        }
                        else
                        {
                            print("Error")
                        }
                        
                        
                }
                
                
            }
            else if pickerView.tag == 2
            {
                
                if(manyCities.count == 0){
                    return;
                }
                
                self.idCity = manyCities[row].CityID!
                txtCity.text = manyCities[row].CityName
                
            }

    }
    
    
}

