//
//  vcMyQRCode.swift
//  StaffLeadwayAccessControlApp
//
//  Created by MacUser on 9/5/19.
//  Copyright © 2019 MacUser. All rights reserved.
//

import UIKit
import SVProgressHUD
import LocalAuthentication
import CommonCrypto

class vcMyQRCode: UIViewController, UITextFieldDelegate{

    var txtOldpin:UITextField!
    var txtNewpin:UITextField!
    
    
    
    let context = LAContext()
    
    var storedPin = UserDefaults.standard.string(forKey: "UserPIN")
    var noteTextField:UITextField!
    
//    var fName:String = UserDefaults.standard.object(forKey: "loggedFirstname") as! String
//    var sName:String = UserDefaults.standard.object(forKey: "loggedSurname") as! String
//    var CompanyName:String = UserDefaults.standard.object(forKey: "loggedCompnayName") as! String
//    var staffID:Int = UserDefaults.standard.integer(forKey: "loggedStaffID")
//    var QRCode:String = UserDefaults.standard.object(forKey: "loggedQrCode") as! String
//    var QrCode:Data = UserDefaults.standard.data(forKey: "loggedUrlData")!
//
    var fName:String = ""
    var sName:String = ""
    var CompanyName:String = ""
    var staffID:Int = 0
    var QRCode:String = ""
    //var QrCode:Data = Data("\u{24}")
    
    var newQRcode:String = ""
    var newerQR: String = ""
    
    @IBOutlet weak var imgBlocker: UIImageView!
    
    @IBOutlet weak var btnCloseQrCode: UIButton!
    @IBOutlet weak var lblFirstname: UILabel!
    @IBOutlet weak var lblSurname: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblStaffID: UILabel!
    @IBOutlet weak var imgQR: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //askForPin()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Group")!)
        EnsureQrCodeSecure()
        btnCloseQrCode.layer.cornerRadius = 8.0
        btnCloseQrCode.clipsToBounds = true
        
        //imgQR.removeFromSuperview()
        //self.mainADLogin("", "", true);

        
        
        lblFirstname.text = fName
        lblSurname.text = sName
        lblCompanyName.text = CompanyName
        lblStaffID.text = "\(staffID)"
        
        self.title = "My QR Code"
        
        
        let mailbutton = UIBarButtonItem(title: "Change PIN", style: .plain, target: self, action: #selector(changeStatus(_:)))
        navigationItem.rightBarButtonItem = mailbutton
        // Do any additional setup after loading the view.
    }
    
    @objc func changeStatus(_ sender: Any) {
        let changePinController = UIAlertController(title: "Change Pin", message: "Would You Like Your Pin", preferredStyle: .alert)
        
        
        
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: ({Void in
            self.txtOldpin = changePinController.textFields![0] as UITextField
            self.txtNewpin = changePinController.textFields![1] as UITextField
            
            
            let SaltPin_1 = "WATER" + self.txtOldpin.text![0] + "EARTH" + self.txtOldpin.text![1] + "FIRE" + self.txtOldpin.text![2] + "AIR" + self.txtOldpin.text![3]
            
            let md5Data = self.md5(SaltPin_1)
            let md5String = self.dataWithHexString(hex: md5Data)
            let base64tings = md5String.base64EncodedString()
            let newmd5Data = self.md5(base64tings)
            
            let newmd5String = self.dataWithHexString(hex: newmd5Data)
            let newbase64ting = newmd5String.base64EncodedString()
            
            if newbase64ting != self.storedPin{
                changePinController.message = "Pin Does Not Match"
            }else {
                
            }
            
        }))
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: ({Void in }))
        changePinController.addTextField(configurationHandler: { (textfield : UITextField!) -> Void in textfield.placeholder = "Enter Old Pin"; textfield.keyboardType = .numberPad; textfield.delegate = self; textfield.textAlignment = .center; textfield.isSecureTextEntry = true  })
        changePinController.addTextField(configurationHandler: { (textfield : UITextField!) -> Void in textfield.placeholder = "Enter New Pin"; textfield.keyboardType = .numberPad; textfield.delegate = self; textfield.textAlignment = .center; textfield.isSecureTextEntry = true  })
        changePinController.addAction(submitAction)
        changePinController.addAction(cancelAction)
        self.present(changePinController, animated: true, completion: nil)
    }

    
    
    func EnsureQrCodeSecure(){
        if UserDefaults.standard.bool(forKey: "LocalAuth") == true{
        if self.context.canEvaluatePolicy( LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            // Biome try is available on the device
            if #available(iOS 11.0, *) {
                if (self.context.biometryType == LABiometryType.faceID) {
                    // Device support Face ID
                    //self.btnbiometric.setBackgroundImage(UIImage(named: "face-scanner"), for: .normal)
                    //self.btnbiometric.setBackgroundImage(UIImage(named: "fingerprint"), for: .normal)
                    let faceIDAlert = UIAlertController(title: "Face ID", message: "Secure QR Code With FaceID", preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: ({Void in self.doFingerPrintAuth()}))
                    faceIDAlert.addAction(confirmAction)
                    self.present(faceIDAlert, animated: true, completion: nil)
                    
                    
                } else if self.context.biometryType == LABiometryType.touchID {
                    // Device supports Touch ID
                    //self.btnbiometric.setBackgroundImage(UIImage(named: "fingerprint"), for: .normal)
                    doFingerPrintAuth()
                    
                } else {
                    // Device has no biometric support
                    self.askForPin()
                }
            } else {
                // Fallback on earlier versions
                self.askForPin()
            }
            
            
        } else {
            self.askForPin()
            // Biometry is not available on the device
            //self.btnbiometric.isHidden = true
        }
        }else{
            self.askForPin()
        }
        
        
    }
    
    func bringImg(){
            }
    
    
    func doFingerPrintAuth() {
        dismissKeyboard();
        let context: LAContext = LAContext();
        if (context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "We need your Biometrics", reply: {
                (wasSuccessful, error) in
                if (wasSuccessful) {
                    
                    DispatchQueue.main.async {
                        //self.imgQR.image = UIImage(data: self.QrCode as Data)
                    }
                    
                    
           //self.mainADLogin("", "", true);
                }
                if((error) != nil){
                    
                    self.askForPin()
                }
                if(!wasSuccessful){
                    self.askForPin()
                }
                
            });
        } else {
            
        }
    }
    

    func askForPin(){
        
        let alertcontroller = UIAlertController(title: "Confirm", message: "Input PIN for QR Code", preferredStyle: .alert)
        
        let alertcontroller1 = UIAlertController(title: "Failed", message: "Try Again", preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Confirm", style: .default, handler: {alert -> Void in
            self.noteTextField = alertcontroller.textFields![0] as UITextField;
            
            let SaltPin_1 = "WATER" + self.noteTextField.text![0] + "EARTH" + self.noteTextField.text![1] + "FIRE" + self.noteTextField.text![2] + "AIR" + self.noteTextField.text![3]
            
            let md5Data = self.md5(SaltPin_1)
            let md5String = self.dataWithHexString(hex: md5Data)
            let base64tings = md5String.base64EncodedString()
            let newmd5Data = self.md5(base64tings)
            
            let newmd5String = self.dataWithHexString(hex: newmd5Data)
            let newbase64ting = newmd5String.base64EncodedString()

            
            if(newbase64ting != self.storedPin){
                
                self.present(alertcontroller1, animated: true, completion: nil)

            }else{alertcontroller.removeFromParent()
                //self.imgQR.image = UIImage(data: self.QrCode as Data)

            }
        })
        
        
        alertcontroller.addTextField(configurationHandler: { (textfield : UITextField!) -> Void in textfield.placeholder = "Ente Text Here"; textfield.keyboardType = .numberPad; textfield.delegate = self; textfield.textAlignment = .center; textfield.isSecureTextEntry = true})
        
        alertcontroller.addAction(save)
        //alertcontroller.addAction(cancelaction)
        //self.present(alertcontroller, animated: true, completion: nil)
        
        
        
        let failed = UIAlertAction(title: "Confirm", style: .default, handler: {alert -> Void in
            self.noteTextField = alertcontroller.textFields![0] as UITextField;
            if(self.noteTextField.text != self.storedPin){
                
                self.present(alertcontroller, animated: true, completion: nil)
                
            }else{alertcontroller.removeFromParent()}
        })
        
        
        //alertcontroller.addTextField(configurationHandler: { (textfield : UITextField!) -> Void in textfield.placeholder = "Ente Text Here"; textfield.keyboardType = .numberPad; textfield.delegate = self; textfield.textAlignment = .center})
        
        alertcontroller1.addAction(failed)
        self.present(alertcontroller, animated: true, completion: nil)


        
    }
    
    
    @IBAction func pushToHome(){
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LandingPage") as! UITabBarController
        //tabBarController!.selectedViewController = controller
        self.present(controller, animated: true, completion: nil)    }
    
    
    
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
