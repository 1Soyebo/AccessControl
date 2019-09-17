//
//  ViewController.swift
//  StaffLeadwayAccessControlApp
//
//  Created by MacUser on 9/4/19.
//  Copyright © 2019 MacUser. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SkyFloatingLabelTextField
import LocalAuthentication
import Foundation
import CommonCrypto


class ViewController: UIViewController, UITextFieldDelegate {

    //var loggedStat:Bool!
    let context = LAContext()
    var encryptedpin:String!
    
    
    var noteTextField: UITextField!
    var ResetTxt:UITextField!
    var Pin:String!
    
    var QRCode:String = ""
    var newQRcode:String = ""
    var newerQR: String = ""
    
    @IBOutlet weak var txtStaffID: UITextField!
    @IBOutlet weak var btnTap: UIButton!
    
    
    var DeviceID:String = ""
    var loggedData:AnyObject = [] as AnyObject
    var loggedStats:Any = [] as Any

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Group")!)
        //noteTextField.keyboardType = .numberPad
        
       txtStaffID.layer.cornerRadius = 8.0
        txtStaffID.clipsToBounds = true
        btnTap.layer.cornerRadius = 8.0
        btnTap.clipsToBounds = true
        
        hideKeyboardWhenTappedAround()
        self.title = "Login"
        
        let state = UserDefaults.standard.bool(forKey: "LoggedStatus")
        if(state){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LandingPage") as! UITabBarController
            //tabBarController!.selectedViewController = controller
            self.present(controller, animated: true, completion: nil)
        }
        txtStaffID.keyboardType = .numberPad
        txtStaffID.layer.borderColor = UIColor.orange.cgColor
        txtStaffID.layer.borderWidth = 2
        
        if(UserDefaults.standard.bool(forKey: "NotFirstTime")){
            self.AlertToAddPin()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func btnResetDevice(_ sender: Any) {
        self.ResetDeviceID()
    }
    
    
    
    func ResetDeviceID(){
        let ResetDeviceController = UIAlertController(title: "Reset Device", message: "Do you want to reset your Device ID", preferredStyle: .alert)
        
        
        
        let ConfirmAction = UIAlertAction(title: "Confirm", style: .default, handler: ({Void in
            self.ResetTxt = ResetDeviceController.textFields![0] as UITextField
            SVProgressHUD.show()
            
            let todosEndpoint: String = "http://dynamics.somee.com/api/Staff/ResetDeviceID"
            
            
            
            let param:Parameters = ["StaffID":"\(self.ResetTxt.text!)"]
            //print(txtStaffID.text!)
            print("2")
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
                    //let passcode = json[]
                    
                    if(success){
                        SVProgressHUD.showSuccess(withStatus: "Try To Login")
                        ResetDeviceController.removeFromParent()
                    }else{
                        ResetDeviceController.message = "Failed"
                    }
                    
            }
            
            
        })
        )
        
        
        let DenyAction = UIAlertAction(title: "Deny", style: .destructive, handler: ({Void in}))
        ResetDeviceController.addTextField(configurationHandler: { (textfield : UITextField!) -> Void in textfield.placeholder = "Ente StaffID"; textfield.keyboardType = .numberPad; textfield.textAlignment = .center})
        ResetDeviceController.addAction(ConfirmAction)
        ResetDeviceController.addAction(DenyAction)
        self.present(ResetDeviceController, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func btnLogin(_ sender: Any) {
        
        
        
        if txtStaffID.text!.isEmpty{
            SVProgressHUD.showError(withStatus: "Input Staff ID")
        }else{
        SVProgressHUD.show()
            //txtStaffID.text = self.Pin
            
        DeviceID = UIDevice.current.name + UIDevice.current.identifierForVendor!.uuidString 
        //DeviceID = "18651177-1006-4D2E-82F8-A921855412F9"
        print(DeviceID)
        
        let todosEndpoint: String = "http://dynamics.somee.com/api/Staff/stafflogin"
        
        
        
        let param:Parameters = ["StaffID":"\(txtStaffID.text!)", "Device_ID":DeviceID]
            print(txtStaffID.text!)
            print("2")
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
                //let passcode = json[]

                if(success){
                    SVProgressHUD.showSuccess(withStatus: message)
                    self.loggedData = json["data"] as AnyObject
                    self.loggedStats = self.loggedData
                    let d = self.loggedStats as! Dictionary<String, Any>
                    
                    let StaffID = d["StaffID"] as! Int
                    UserDefaults.standard.set(StaffID, forKey: "loggedStaffID")
                    //self.loggedStat = true
                    let Fistname = d["FirstName"] as! String
                    UserDefaults.standard.set(Fistname, forKey: "loggedFirstname")
                    let Surname = d["Surname"] as! String
                    UserDefaults.standard.set(Surname, forKey: "loggedSurname")
                    let email = d["Email"] as! String
                    UserDefaults.standard.set(email, forKey: "loggedEmail")
                    let phonenumber = d["PhoneNumber"] as! String
                    UserDefaults.standard.set(phonenumber, forKey: "loggedPhoneNumber")
                    let CompanyName = d["CompanyName"] as! String
                    UserDefaults.standard.set(CompanyName, forKey: "loggedCompnayName")
                    let FloorID = d["FloorID"] as! Int
                    UserDefaults.standard.set(FloorID, forKey: "loggedFloorID")
                    let QRCodeUrl = d["QRCodeURL"] as! String
                    UserDefaults.standard.set(QRCodeUrl, forKey: "loggedQrCode")
                    let AccessCode = d["AccessCode"] as! String
                    UserDefaults.standard.set(AccessCode, forKey: "loggedAccessCode")
                    let passcode = d["Passcode"] as! String
                    print(passcode)
                    
                    var num = "5331"
                    var SaltPin_1 = "WATER" + num[0] + "EARTH" + num[1] + "FIRE" + num[2] + "AIR" + num[3]

                    var md5Data = self.md5(SaltPin_1)
                    var md5String = self.dataWithHexString(hex: md5Data)
                    var base64tings = md5String.base64EncodedString()

                    print(base64tings)

                    var newmd5Data = self.md5(base64tings)

                    var newmd5String = self.dataWithHexString(hex: newmd5Data)
                    var newbase64ting = newmd5String.base64EncodedString()
                    print(newbase64ting)
                    
                    UserDefaults.standard.set(passcode, forKey: "UserPIN")
                    self.Pin = UserDefaults.standard.string(forKey: "UserPin")
                    
                    
                    self.newQRcode = QRCodeUrl.replacingOccurrences(of: "d:\\DZHosts\\LocalUser\\Massive_Dynamics\\", with: "http://")
                    self.newerQR = self.newQRcode.replacingOccurrences(of: "\\", with: "/")
                    print(self.newerQR)
                    if let url = NSURL(string: self.newerQR){
                        if let data = NSData(contentsOf: url as URL){
                            UserDefaults.standard.set(data, forKey: "loggedUrlData")
                            //viewCode.ImgData = data
                            //imgQrCode.image = UIImage(data: data as Data)
                        }
                    }

                    
                    
                    
                    print(self.Pin)

                    //SVProgressHUD.dismiss()
                    
                    //self.Pin =
                    
                    if !UserDefaults.standard.bool(forKey: "NotFirstTime") {
                        self.AlertToAddPin()
                    
                    }
                    
                    
                    print(self.encryptedpin)
                    
                    
                    
                    
                    if self.encryptedpin == UserDefaults.standard.string(forKey: "UserPIN"){
                    
                    if UserDefaults.standard.bool(forKey: "LocalAuth") == true || UserDefaults.standard.bool(forKey: "PassCodesMatch") == true {
                    UserDefaults.standard.set(true, forKey: "LoggedStatus")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "LandingPage")
                    self.present(controller, animated: true, completion: nil)
                    }
                    }else {
                        
                    }
                }
                else
                {
                    //print(self.DeviceID)
                    //print(success)
                    //print("k")
                    
                    //print("j")
                    SVProgressHUD.showError(withStatus: message)
                }
        
        
        }
    
    }
}
    
    
    func ResetPin(){
        
    }
    
     func doFingerPrintAuth() {
        dismissKeyboard();
        let context: LAContext = LAContext();
        if (context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "We need your Biometrics", reply: {
                (wasSuccessful, error) in
                if (wasSuccessful) {
                    UserDefaults.standard.set(true, forKey: "LocalAuth")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "LandingPage") as! UITabBarController
                    //tabBarController!.selectedViewController = controller
                    self.present(controller, animated: true, completion: nil)
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let controller = storyboard.instantiateViewController(withIdentifier: "LandingPage")
//                    self.present(controller, animated: true, completion: nil)
                    //self.mainADLogin("", "", true);
                }
                if((error) != nil){
                    
                    self.AlertToAddPin()
                }
                if(!wasSuccessful){
                    self.AlertToAddPin()
                }
                
            });
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LandingPage") as! UITabBarController
            //tabBarController!.selectedViewController = controller
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func AlertToAddPin() {
        
        
        
            let failedcontroller = UIAlertController(title: "PIN", message: "PIN FAILED", preferredStyle: .alert)

            let alertcontroller = UIAlertController(title: "PIN", message: "Check Your Mail For Your PIN", preferredStyle: .alert)
            
            let save = UIAlertAction(title: "Submit", style: .default, handler: {alert -> Void in
                self.noteTextField = alertcontroller.textFields![0] as UITextField
                
                var SaltPin_1 = "WATER" + self.noteTextField.text![0] + "EARTH" + self.noteTextField.text![1] + "FIRE" + self.noteTextField.text![2] + "AIR" + self.noteTextField.text![3]
                
                var md5Data = self.md5(SaltPin_1)
                var md5String = self.dataWithHexString(hex: md5Data)
                var base64tings = md5String.base64EncodedString()
                var newmd5Data = self.md5(base64tings)
                
                var newmd5String = self.dataWithHexString(hex: newmd5Data)
                var newbase64ting = newmd5String.base64EncodedString()
                self.encryptedpin = newbase64ting
                
                if(UserDefaults.standard.bool(forKey: "NotFirstTime")){
                    print("bread")
                }
                
                if !UserDefaults.standard.bool(forKey: "LocalAuth"){
                    print(UserDefaults.standard.bool(forKey: "LocalAuth"))
                    self.faceOrPhoneID()
                }
                
                if(newbase64ting != UserDefaults.standard.string(forKey: "UserPIN")){
                    
                    alertcontroller.message = "Failed"
                    //print(self.Pin)
                    self.present(alertcontroller, animated: true, completion: nil)

                }else{
                    UserDefaults.standard.set(true, forKey: "NotFirstTime")
                    UserDefaults.standard.set(true, forKey: "PassCodesMatch")
                    
                    if !UserDefaults.standard.bool(forKey: "LocalAuth"){
                        print(UserDefaults.standard.bool(forKey: "LocalAuth"))
                        self.faceOrPhoneID()
                    }
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "LandingPage")
                    self.present(controller, animated: true, completion: nil)
                    
                }
                //                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let controller = storyboard.instantiateViewController(withIdentifier: "LandingPage")
//                self.present(controller, animated: true, completion: nil)
                //var text: String = noteTextField.text!
            })
        
        
        
            let cancelaction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action : UIAlertAction!) -> Void in})
            
        alertcontroller.addTextField(configurationHandler: { (textfield : UITextField!) -> Void in textfield.placeholder = "Ente Text Here"; textfield.keyboardType = .numberPad; textfield.delegate = self; textfield.textAlignment = .center; textfield.isSecureTextEntry = true  })
            
            alertcontroller.addAction(save)
            alertcontroller.addAction(cancelaction)
        
        if(UserDefaults.standard.bool(forKey: "NotFirstTime")){
            alertcontroller.message = "Welcome Back, Input Login"
        }
        
            self.present(alertcontroller, animated: true, completion: nil)
            
        
        let save2 = UIAlertAction(title: "Add", style: .default, handler: {alert -> Void in
            self.noteTextField = failedcontroller.textFields![0] as UITextField
            
            if( self.encryptedpin != UserDefaults.standard.string(forKey: "UserPIN")){
                self.present(failedcontroller, animated: true, completion: nil)
                
            }
            
        })
        
        let cancelaction2 = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action : UIAlertAction!) -> Void in})
        let ResetPin = UIAlertAction(title: "Reset Pin", style: .default, handler: ({Void in self.ResetPin()}))
        
        failedcontroller.addTextField(configurationHandler: { (textfield : UITextField!) -> Void in textfield.placeholder = "Ente Text Here"; textfield.keyboardType = .numberPad; textfield.delegate = self; textfield.textAlignment = .center; textfield.isSecureTextEntry = true  })
        
        failedcontroller.addAction(save2)
        failedcontroller.addAction(cancelaction2)
        failedcontroller.addAction(ResetPin)
        self.present(failedcontroller, animated: true, completion: nil)


        
    }
    
    
    
    
    func faceOrPhoneID(){
        
        if self.context.canEvaluatePolicy( LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            // Biome try is available on the device
            
            
            if #available(iOS 11.0, *) {
                if (self.context.biometryType == LABiometryType.faceID) {
                    // Device support Face ID
                    //self.btnbiometric.setBackgroundImage(UIImage(named: "face-scanner"), for: .normal)
                    //self.btnbiometric.setBackgroundImage(UIImage(named: "fingerprint"), for: .normal)
                    let faceIDAlert = UIAlertController(title: "Face ID", message: "Secure QR Code With FaceID", preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: ({Void in self.doFingerPrintAuth()}))
                    let noAction = UIAlertAction(title: "Deny", style: .destructive, handler: ({Void in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "LandingPage")
                        self.present(controller, animated: true, completion: nil)

                    }))
                    faceIDAlert.addAction(confirmAction)
                    faceIDAlert.addAction(noAction)
                    self.present(faceIDAlert, animated: true, completion: nil)
                    
                    
                } else if self.context.biometryType == LABiometryType.touchID {
                    // Device supports Touch ID
                    //self.btnbiometric.setBackgroundImage(UIImage(named: "fingerprint"), for: .normal)
                    let faceIDAlert = UIAlertController(title: "Touch ID", message: "Secure QR Code With TouchID", preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: ({Void in self.doFingerPrintAuth()}))
                    let noAction = UIAlertAction(title: "Deny", style: .destructive, handler: ({Void in}))
                    faceIDAlert.addAction(confirmAction)
                    faceIDAlert.addAction(noAction)
                    self.present(faceIDAlert, animated: true, completion: nil)
                    
                    
                } else {
                    print("Device has no biometric support")
                    //self.AlertToAddPin()
                }
            } else {
                print("Fallback on earlier versions")
                //self.AlertToAddPin()
            }
            
            
        } else {
            //.AlertToAddPin()
            print("Biometry is not available on the device")
            //self.btnbiometric.isHidden = true
        }
        
    }
    
    func dataWithHexString(hex: String) -> Data {
        var hex = hex
        var data = Data()
        while(hex.count > 0) {
            let subIndex = hex.index(hex.startIndex, offsetBy: 2)
            let c = String(hex[..<subIndex])
            hex = String(hex[subIndex...])
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }
    
    func md5(_ string: String) -> String {
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate(capacity: 1)
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        return hexString
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        var result:Bool!
        
        
        if textField.text!.count < 4 {
                let disallowedCharacterSet = NSCharacterSet(charactersIn: "0123456789").inverted
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
            
            if !replacementStringIsLegal{
                return false
            }
        }
        
        
        return range.location < 4
    }
}



extension String {
    
    
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    
    
}
