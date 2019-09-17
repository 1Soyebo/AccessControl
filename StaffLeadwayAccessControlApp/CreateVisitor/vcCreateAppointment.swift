//
//  vcCreateAppointment.swift
//  StaffLeadwayAccessControlApp
//
//  Created by MacUser on 9/5/19.
//  Copyright © 2019 MacUser. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class vcCreateAppointment: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    var apiTime:String!
    
    @IBOutlet weak var btnNext: UIButton!
    
    var nowLaterPicker : UIPickerView!
    var reasonPicker:UIPickerView!
    
    
    var StaffID:Int = UserDefaults.standard.integer(forKey: "loggedStaffID")
    
    //let inputView = UIView?.self
    
    @IBOutlet weak var imgCard: UIImageView!
    
    //let picker = UIPickerView()
    let toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))

    
    let datePickerView  : UIDatePicker = UIDatePicker()
    let arrivalTime : UIDatePicker = UIDatePicker()
    let durationPickerView : UIDatePicker = UIDatePicker()
    
    
    @IBOutlet weak var btnNowOrLater: UIButton!
    @IBOutlet weak var txtArrivalDste: UITextField!
    @IBOutlet weak var txtArrivalTime: UITextField!
    @IBOutlet weak var txtDuration: UITextField!
    @IBOutlet weak var txtResaonForVisit: UITextField!
    @IBOutlet weak var lblVisitorName: UILabel!
    
    var list = ["BUSINESS REASONS", "PERSONAL", "OTHER"]
    var nowOrLater = ["NOW", "LATER"]
    var VistorID:Int = 0
    var VisitorName:String = ""
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        txtArrivalDste.text = dateFormatter.string(from: sender.date)
        self.view.endEditing(true)
    }
    
    
    @objc func handleTimePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        txtArrivalTime.text = dateFormatter.string(from: sender.date)
        self.view.endEditing(true)
        dateFormatter.dateFormat = "HH:MM"
        apiTime = dateFormatter.string(from: sender.date)
        //        txtDuration.text = dateFormatter.string(from: sender.date)
        
    }
    
    @objc func handleDurationPicker(_ sender: UIDatePicker) {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm"
        txtDuration.text = dateFormatter1.string(from: sender.date)
        self.view.endEditing(true)
        //txtDuration.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        //nowLaterPicker.tag = 2
        btnNext.layer.cornerRadius = 8.0
        btnNext.clipsToBounds = true
        //reasonPicker.tag = 3
        btnNowOrLater.titleLabel?.text = "NOW OR LATER"
        
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 240))
        
        imgCard.layer.cornerRadius = 8.0
        imgCard.clipsToBounds = true
//

        
        reasonPicker=UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 240))
        reasonPicker.dataSource=self;
        reasonPicker.delegate=self;
        reasonPicker.tag=1

        inputView.addSubview(reasonPicker)
        txtResaonForVisit.inputView = inputView

        
        
               imgCard.alpha = 0.8
        lblVisitorName.layer.borderColor = UIColor.black.cgColor
        lblVisitorName.layer.borderWidth = 2
        
        
        durationPickerView.datePickerMode = UIDatePicker.Mode.countDownTimer
        txtDuration.inputView = durationPickerView
        durationPickerView.addTarget(self, action: #selector(handleDurationPicker(_:)), for: UIControl.Event.valueChanged)
        
        
        
        
        arrivalTime.datePickerMode = UIDatePicker.Mode.time
        txtArrivalTime.inputView = arrivalTime
        arrivalTime.addTarget(self, action: #selector(handleTimePicker(_:)), for: UIControl.Event.valueChanged)
        
        
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.minimumDate = Date()
        txtArrivalDste.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        
        lblVisitorName.text = VisitorName
        
        
        

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
    
    
    @IBAction func YOUR_BUTTON__TAP_ACTION(_ sender: UIButton) {
        //picker = UIPickerView.init()
        
        //let inputView1 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        nowLaterPicker=UIPickerView(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300))
        nowLaterPicker.dataSource=self;
        nowLaterPicker.delegate=self;
        nowLaterPicker.tag=2;
        
        nowLaterPicker.backgroundColor = UIColor.init(red: 204/255.0, green: 206/255.0, blue: 211/255.0, alpha: 1)
        nowLaterPicker.setValue(UIColor.black, forKey: "textColor")
        nowLaterPicker.autoresizingMask = .flexibleWidth
        nowLaterPicker.contentMode = .center
        
        //inputView1.addSubview(nowLaterPicker)
        //btnNowOrLater.inputView = inputView


        //reasonPicker.removeFromSuperview()
        datePickerView.removeFromSuperview()
        arrivalTime.removeFromSuperview()
        durationPickerView.removeFromSuperview()
        self.view.addSubview(nowLaterPicker)
        
        
    }
    
    
    
    @IBAction func btnCreateAppoinment(_ sender: Any) {
        
        if(txtArrivalTime.text!.isEmpty){
            SVProgressHUD.showError(withStatus: "Input Arriavl Time")
        }else if(txtArrivalDste.text!.isEmpty){
            SVProgressHUD.showError(withStatus: "Input Arrival Date")
        }else if(txtDuration.text!.isEmpty){
            SVProgressHUD.showError(withStatus: "Input Duration")
        }else if(txtResaonForVisit.text!.isEmpty){
            SVProgressHUD.showError(withStatus: "Input Reason")
        }else{
        
        
        
        SVProgressHUD.show()
        let todosEndpoint: String = "http://Dynamics.somee.com/api/Staff/CreateAppointment"
        
        /*let newTodo: [String: Any] = ["SupplierName": "a test", "SupAddress": "a test"]*/
        
        let param:Parameters = ["VisitorID":"\(VistorID)", "StaffID":"\(StaffID)", "ExpectedDate":"\(txtArrivalDste.text!)", "ExpectedTime":"\(apiTime!)", "ReasonVisit":"\(txtResaonForVisit.text!)", "ScheduledVisit":"false", "Duration":"\(txtDuration.text!)", "Validity":"true"]
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
                    
                    //SVProgressHUD.dismiss()
                    self.navigationController?.popToRootViewController(animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: message)
                }
        }
    }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return list.count
            
        }
        else if pickerView.tag == 2{
            return nowOrLater.count
        }else{
            return 0
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            return list[row]
        }else if pickerView.tag == 2{
            return nowOrLater[row]
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.view.endEditing(true)
        
        if pickerView.tag == 1{
        txtResaonForVisit.text = list[row]
        }else if pickerView.tag == 2{
            if nowOrLater[row] == "NOW"{
                btnNowOrLater.backgroundColor = UIColor.darkGray
                btnNowOrLater.titleLabel?.textAlignment = .center
                btnNowOrLater.setTitle("NOW", for: UIControl.State.normal)
                
                //btnNowOrLater.titleLabel?.isHighlighted = true
                //btnNowOrLater.titleLabel?.highlightedTextColor = UIColor.lightGray
                //txtArrivalTime.removeFromSuperview()
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.dateFormat = "MM-dd-yyyy"
                let dateString = "\(dateFormatter.string(from: Date() as Date))"
                txtArrivalDste.text = String(dateString)
                txtArrivalDste.isUserInteractionEnabled = false
                
                
                //Time
                let timeFormatter = DateFormatter()
                timeFormatter.timeStyle = .short
                let timeString = "\(timeFormatter.string(from: Date() as Date))"
                txtArrivalTime.text = String(timeString)
                timeFormatter.dateFormat = "HH:MM"
                apiTime = "\(timeFormatter.string(from: Date() as Date))"
                txtArrivalTime.isUserInteractionEnabled = false
                nowLaterPicker.removeFromSuperview()
                
            }else if nowOrLater[row] == "LATER"{
                
                btnNowOrLater.backgroundColor = UIColor.lightGray
                btnNowOrLater.titleLabel?.textAlignment = .center
                btnNowOrLater.setTitle("LATER", for: UIControl.State.normal)
                nowLaterPicker.removeFromSuperview()
               
                //btnNowOrLater.isHighlighted = false
                txtArrivalTime.isUserInteractionEnabled = true
                txtArrivalDste.isUserInteractionEnabled = true
                
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
