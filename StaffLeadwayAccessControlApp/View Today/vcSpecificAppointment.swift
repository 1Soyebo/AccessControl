//
//  vcSpecificAppointment.swift
//  StaffLeadwayAccessControlApp
//
//  Created by MacUser on 9/6/19.
//  Copyright © 2019 MacUser. All rights reserved.
//

import UIKit
import Floaty
import SVProgressHUD
import Alamofire

class vcSpecificAppointment: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var apiRequestResponse:Int!
    
    var staffID = UserDefaults.standard.string(forKey: "loggedStaffID")
    
    var specificApp = [] as AnyObject
    
    var ReceptionistCooment:String!
    
    var RequestRespons:Int!
    
    var frameimg = CGRect(x: 15, y: 5, width: 25, height: 25)
    let someButton = UIButton()
    
    var specificAppointmentDetails: DetailsAppoinment!
    
    var specAppoint:Any = [] as Any
    
    var QRCode:String = ""
    var newQRcode:String = ""
    var newerQR: String = ""

    var fName:String = ""
    var sName:String = ""
    var VisID:Int!
    
    
    @IBOutlet weak var tblAppointmentDetails: UITableView!
    
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var lblAppointmentID: UILabel!
//    @IBOutlet weak var lblAccessCode: UILabel!
//    @IBOutlet weak var lblFirstName: UILabel!
//    @IBOutlet weak var lblLastName: UILabel!
//    @IBOutlet weak var lblPhoneNumber: UILabel!
//    @IBOutlet weak var lblEmail: UILabel!
//    @IBOutlet weak var lblDate: UILabel!
//    @IBOutlet weak var lblTime: UILabel!
//    @IBOutlet weak var lblDuration: UILabel!
//    @IBOutlet weak var lblReason: UILabel!
//    @IBOutlet weak var imgQrCode: UIImageView!
//    @IBOutlet weak var lblStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let floatty = Floaty()
        floatty.plusColor = UIColor.white
        floatty.buttonColor = UIColor.init(red: 234.0/255.0, green: 91.0/255.0, blue: 12.0/255.0, alpha: 1)
        floatty.addItem("Create Appointmment", icon: UIImage(named: "add")!, handler: { item in self.moveToCreateAppointment()})
        floatty.paddingY += tabBarController!.tabBar.frame.size.height
        self.view.addSubview(floatty)
        
        let nib = UINib.init(nibName: "cellSpecific", bundle:nil)
        self.tblAppointmentDetails.register(nib, forCellReuseIdentifier: "cellSpecific")
        tblAppointmentDetails.rowHeight = 50
        //tblAppointmentDetails.backgroundView = UIImageView(image: UIImage(named: "Group")) 
        tblAppointmentDetails.separatorStyle = .none
        
        self.title = "Visitor Details"
        assignData()
        
     
        
        
        let mailbutton = UIBarButtonItem(title: "Change Status", style: .plain, target: self, action: #selector(changeStatus(_:)))
        navigationItem.rightBarButtonItem = mailbutton
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        tblAppointmentDetails.refreshControl = refresh
        
        // Do any additional setup after loading the view.
    }

    
    
    
    @IBAction func refreshTable(){
        GetSpecAppointments()
    }
    
    @objc func refresh(){
        refreshTable()
        tblAppointmentDetails.refreshControl?.endRefreshing()
    }
    
    func GetSpecAppointments(){
        SVProgressHUD.show()
        let todoEndpoint: String = "http://dynamics.somee.com/api/Visitor/ViewReceptionistAppointment/\(specificAppointmentDetails.AppoinmentID!)"
        Alamofire.request(todoEndpoint)
            .responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /todos/1")
                    SVProgressHUD.showError(withStatus: "Network Error")
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
                    self.specificApp = json["pointments"] as AnyObject
                    self.specificAppointmentDetails = nil
                    
                    self.specAppoint = self.specificApp
                    self.assignData()
                    self.tblAppointmentDetails.reloadData()
                    SVProgressHUD.dismiss()
                    
                    
                }
                else{
                    print("Error")
                }
                
        }
        
    }

    
    
    @objc func changeStatus(_ sender: Any) {
        let statusController = UIAlertController(title: "Status", message: "Change Appointment Status", preferredStyle: .alert)
        let ApproveAction = UIAlertAction(title: "Approve", style: .default, handler: ({Void in self.RequestRespons = 1;
            self.postResponse()
        }))
        let AppointmentCancel = UIAlertAction(title: "Cancel Appointment", style: .destructive, handler: ({Void in self.RequestRespons = 0;
            self.postResponse()
        }))
        let WaitAction = UIAlertAction(title: "On Hold", style: .default, handler: ({Void in self.RequestRespons = 2;
            self.postResponse()
        }))
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: ({Void in }))
        
        statusController.addAction(ApproveAction)
        statusController.addAction(WaitAction)
        statusController.addAction(AppointmentCancel)

        
        statusController.addAction(cancel)
        
        if apiRequestResponse == 0 {
            AppointmentCancel.isEnabled = false
        }
        if apiRequestResponse == 1 {
         ApproveAction.isEnabled = false
        }
        if apiRequestResponse == 2 {
            WaitAction.isEnabled = false
        }
        self.present(statusController, animated: true, completion: nil)
        
    }
    
    
    func postResponse(){
        
        let todosEndpoint: String = "http://Dynamics.somee.com/api/Staff/ChangeAppointmentStatus"
        
        /*let newTodo: [String: Any] = ["SupplierName": "a test", "SupAddress": "a test"]*/
        
        let param:Parameters = ["StaffId":staffID!, "AppointmentID":specificAppointmentDetails.AppoinmentID!, "RequestResponse":RequestRespons!]
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
                    
                }else if success == false{
                    SVProgressHUD.showInfo(withStatus: message)
                }
        }

    }
    
    
    func moveToCreateAppointment(){
        let koll = vcCreateAppointment(nibName:"vcCreateAppointment", bundle:nil)
        koll.VisitorName = sName + " " + fName
        koll.VistorID = VisID
        navigationController?.pushViewController(koll, animated: true)
    }

    func assignData(){
        let d = self.specAppoint as! Array<[String: Any]>
        
        let ex_item1 =  d[0]
        //let vName: String = ex_item1["VisitorName"] as! String
        let apID:Int = ex_item1["AppointmentID"] as! Int
        let accCode:String = ex_item1["AccessCode"] as! String
        
        fName = ex_item1["FirstName"] as! String
        sName = ex_item1["Surname"] as! String
        VisID = ex_item1["VisitorID"] as? Int
        
        let SEmail:String = ex_item1["VisitorEmail"] as! String
        let SPhone:String = ex_item1["VisitorPhoneNumber"] as! String
        
        let StaffCompany:String = ex_item1["VisitorCompany"] as! String
        let pectedDate:String = ex_item1["ExpectedDate"] as! String
        
        let pectedTime:String = ex_item1["ExpectedTime"] as! String
        let Duration:String = ex_item1["Duration"] as! String
        
        let reas:String = ex_item1["Reason"] as! String
        
        let status:String = ex_item1["OverallStatus"] as! String
        
        apiRequestResponse = ex_item1["RequestResponse"] as! Int
        
        let QRcodeURL:String = ex_item1["QRCodeURL"] as! String
        
        
        ReceptionistCooment = ex_item1["ReceptionistComment"] as? String
        
        
        specificAppointmentDetails = DetailsAppoinment(AppointmentID: apID, AccCode: accCode, VisFName: fName, VisSName: sName, StaffComp: StaffCompany, StaffNum: SPhone, StaffEmail: SEmail, ExpDate: pectedDate, ExpTime: pectedTime, Duration: Duration, VisReas: reas, Stat: status, QrCode: QRcodeURL, ReceptionistComment: ReceptionistCooment)
        
//        lblAppointmentID.text = "\(specificAppointmentDetails.AppoinmentID!)"
//        lblAccessCode.text = specificAppointmentDetails.AccessCode
//        lblFirstName.text = specificAppointmentDetails.VisFirstName
//        lblLastName.text = specificAppointmentDetails.VisSurName
//        lblPhoneNumber.text = specificAppointmentDetails.StaffPhone
//        lblEmail.text = specificAppointmentDetails.StaffEmail
//        lblDate.text = specificAppointmentDetails.ExpectedDate
//        lblTime.text = specificAppointmentDetails.ExpectedTime
//        lblDuration.text = specificAppointmentDetails.Duration
//        lblReason.text = specificAppointmentDetails.VisReason
//
//        lblStatus.text = specificAppointmentDetails.Status
//        QRCode = specificAppointmentDetails.QRCodeURL!
//
//        self.newQRcode = self.QRCode.replacingOccurrences(of: "d:\\DZHosts\\LocalUser\\Massive_Dynamics\\", with: "http://")
//        self.newerQR = self.newQRcode.replacingOccurrences(of: "\\", with: "/")
//        print(self.newerQR)
//        if let url = NSURL(string: self.newerQR){
//            if let data = NSData(contentsOf: url as URL){
//                //viewCode.ImgData = data
//                imgQrCode.image = UIImage(data: data as Data)
//            }
//        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSpecific", for: indexPath) as! cellSpecific
        //tblAppointmentDetails.rowHeight = 40
        if indexPath.row == 0 {
            cell.lblDisplayName.text = "AppointmentID"
            cell.lblContent.text = "  \(specificAppointmentDetails.AppoinmentID!)"
        }else if indexPath.row == 1{
            cell.lblDisplayName.text = "Access Code"
            cell.lblContent.text = "  " + specificAppointmentDetails.AccessCode!
        }else if indexPath.row == 2 {
            cell.lblDisplayName.text = "First Name"
            cell.lblContent.text = "  " + specificAppointmentDetails.VisFirstName!
        }else if indexPath.row == 3 {
            cell.lblDisplayName.text = "Last Name"
            cell.lblContent.text = "  " + specificAppointmentDetails.VisSurName!
        }else if indexPath.row == 4 {
            cell.lblDisplayName.text = "Visitor Company"
            cell.lblContent.text = "  " + specificAppointmentDetails.StaffCompany!
        }else if indexPath.row == 5{
            cell.lblDisplayName.text = "Phone Number"
            cell.lblContent.text = "  " + specificAppointmentDetails.StaffPhone!
        }else if indexPath.row == 6{
            cell.lblDisplayName.text = "Email"
            cell.lblContent.text = "  " + specificAppointmentDetails.StaffEmail!
        }else if indexPath.row == 7 {
            cell.lblDisplayName.text = "Date"
            cell.lblContent.text = "  " + specificAppointmentDetails.ExpectedDate!
        }else if indexPath.row == 8{
            cell.lblDisplayName.text = "Time"
            cell.lblContent.text = "  " + specificAppointmentDetails.ExpectedTime
        }else if indexPath.row == 9 {
            cell.lblDisplayName.text = "Duration"
            cell.lblContent.text = "  " + specificAppointmentDetails.Duration!
        }else if indexPath.row == 10 {
            cell.lblDisplayName.text = "Reason"
            cell.lblContent.text = "  " + specificAppointmentDetails.VisReason!
        }else if indexPath.row == 11{
            cell.lblDisplayName.text = "Status"
            cell.lblContent.text = "  " + specificAppointmentDetails.Status!
            if specificAppointmentDetails.Status == "Active"{
                cell.lblContent.backgroundColor = UIColor.green
            }else if specificAppointmentDetails.Status == "Expired"{
                cell.lblContent.backgroundColor = UIColor.brown
            }else if specificAppointmentDetails.Status == "On Hold"{
                cell.lblContent.backgroundColor = UIColor.yellow
            }else if specificAppointmentDetails.Status == "Scheduled"{
                cell.lblContent.backgroundColor = UIColor.lightGray
            }else if specificAppointmentDetails.Status == "Cancelled"{
                cell.lblContent.backgroundColor = UIColor.red
            }
            
        
        }else if indexPath.row == 12{
            cell.lblDisplayName.text = "ReceptionistComment"
            cell.lblContent.text = "  " + specificAppointmentDetails.ReceptionistComment!
        }
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblAppointmentDetails.deselectRow(at: indexPath, animated: true)
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
