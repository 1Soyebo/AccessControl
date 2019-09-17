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
import SkyFloatingLabelTextField
import Contacts
import ContactsUI

class vcCreateVisitor: UIViewController, CNContactPickerDelegate{

    
    var thisContact = [CNContact]()
    var isFromSelectContact: Bool!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var img: UIImageView!
    var States:AnyObject = [] as AnyObject
    
    //@IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
        hideKeyboardWhenTappedAround()
        img.alpha = 0.8
        self.title = "Register Visitor"
        txtPhoneNumber.keyboardType = UIKeyboardType.numberPad
        txtEmail.keyboardType = UIKeyboardType.emailAddress
        
        btnNext.layer.cornerRadius = 8.0
        btnNext.clipsToBounds = true
        
        txtEmail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        img.layer.cornerRadius = 8.0
        img.clipsToBounds = true
        txtPhoneNumber.textContentType = .telephoneNumber
        txtEmail.textContentType = .emailAddress
        txtLastName.textContentType = .givenName
        txtFirstName.textContentType = .familyName
    }

    
    @IBAction func selectFromContactButtonTapped(_ sender: Any) {
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        //self.present(cnPicker, animated: true, completion: nil)
        self.navigationController?.present(cnPicker, animated: true, completion: nil);
        //UIApplication.topViewController()?.present(cnPicker, animated: true, completion: nil);
    }

    
    
    func fetchContacts(){
         let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, err) in
            
            if let err = err{
                print("Failed to request access:", err)
                return
            }
            
            if granted{
                print("Access Granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
               
                do{
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in print(contact.givenName)
                        
                    })
                    
                }catch let err {
                    print("Failed to enumerate contacts: ", err)
                }
                
            
            }else{
                print("Access Denied")
                //self.navigationController?.popViewController(animated: true)
            }
            
        }
        
        
        
        
    }
    
    //    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
//
        
//        //fetchContacts()
//        didFetchContacts(contacts: [contact])
//
//        let myContact = contact
//        let myContactFirstName = myContact.givenName
//        let myContactLastName = myContact.familyName
//        //let myContactJobTitle = myContact.jobTitle
//
//        txtFirstName.text = myContactFirstName
//        txtLastName.text = myContactLastName
//
//        // Set the contact's work email address.
//        var myContactWorkEmailAddress: String!
//        for workEmailAddress in contact.emailAddresses {
//            if workEmailAddress.label == CNLabelWork {
//                myContactWorkEmailAddress = workEmailAddress.value as String
//                txtEmail.text = myContactWorkEmailAddress
//                break
//            }
//        }
//
//        // Set the contact's work phone number.
//        var myContactWorkPhoneNumber: String!
//        var myContactWorkPhoneNumberArray = [String]()
//        for mainPhone in contact.phoneNumbers {
//            if mainPhone.label == CNLabelPhoneNumberMain {
//                let mainPhoneValue = mainPhone.value
//                myContactWorkPhoneNumberArray.append(mainPhoneValue.stringValue)
//                myContactWorkPhoneNumber = myContactWorkPhoneNumberArray[0]
//                txtPhoneNumber.text = myContactWorkPhoneNumber
//                break
//            }
//        }
//
//        navigationController?.popViewController(animated: true)
//    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        contacts.forEach { contact in
            if let contactName = contact.givenName as? String {
                let phoneNumber: String = "";
                print("name: " + contactName, "contact.phoneNumbers: ", contact.phoneNumbers.count);
                
                if (contact.phoneNumbers.count > 0) {
                    //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
//                    var fullName = contactName;
//                    let fullNameArr = contactName.components(separatedBy: " ");
//                    if (fullNameArr.count == 1) {
//                        if (!contact.familyName.isEmpty) {
//                            fullName = contactName + " " + contact.familyName;
//                        }
//                    }
                    if (contact.phoneNumbers.count == 1) {
                        
                        txtFirstName.text = contactName;
                        txtLastName.text = contact.familyName
                        txtEmail.text = (contact.emailAddresses.count > 0 ? contact.emailAddresses[0].value as String : "");
                        txtPhoneNumber.text = (contact.phoneNumbers[0].value ).value(forKey: "digits") as? String;
                        isFromSelectContact = true;
                        //prepareRegistrationPageData(vc);
                        
                    } else {
                        
                        txtPhoneNumber.text!.removeAll();
                        //vc.isIndividualRegistration = true;
                        txtFirstName.text = contactName;
                        txtLastName.text = contact.familyName
                        txtEmail.text = (contact.emailAddresses.count > 0 ? contact.emailAddresses[0].value as! String : "");
                        
                        for number in contact.phoneNumbers {
                            txtPhoneNumber.text!.append(number.value.stringValue);
                        }
                        
                        
                    }
                } else {
                    print("There was no phone number found for the selected contact.");
                }
            }
        }
    }
    
    
    func didFetchContacts(contacts: [CNContact]) {
        for contact in contacts {
            self.thisContact.append(contact)
        }
    }
    
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if(text.count < 3 || !text.contains("@")) {
                    floatingLabelTextField.errorMessage = "Invalid email"
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
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
    
    
    @IBAction func btnMoveToAddress(_ sender: Any) {
        
        if (txtFirstName.text?.isEmpty)! || (txtLastName.text?.isEmpty)! || (txtEmail.text?.isEmpty)! || (txtPhoneNumber.text?.isEmpty)!{
            SVProgressHUD.showError(withStatus: "Fill out all fields")
            
        }else if txtPhoneNumber.text!.count > 15 {
            SVProgressHUD.showError(withStatus: "Phone Number is Not Valid")
        }
        else
        {
            SVProgressHUD.show()
            let todoEndpoint: String = "http://Dynamics.somee.com/api/GetListOfStates/1"
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
                    print(json)
                    if(status){
                        
                        self.States = json["statess"] as AnyObject
                        let pushToCity = vcAddress(nibName:"vcAddress", bundle:nil)
                        pushToCity.Firstname = self.txtFirstName.text!
                        pushToCity.LastName = self.txtLastName.text!
                        pushToCity.PhoneNumber = self.txtPhoneNumber.text!
                        pushToCity.Email = self.txtEmail.text!
                        pushToCity.listStates = self.States
                        SVProgressHUD.dismiss()
                        
                        self.navigationController?.pushViewController(pushToCity, animated: true)
                        
                    }
                    else{
                        print("Error")
                    }
                    
            }
            
        }
        
        
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
