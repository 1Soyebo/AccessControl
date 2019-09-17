//
//  vcSpecificAppointment.swift
//  StaffLeadwayAccessControlApp
//
//  Created by MacUser on 9/6/19.
//  Copyright © 2019 MacUser. All rights reserved.
//

import UIKit
import Floaty
import Alamofire
import SVProgressHUD

class vcTodayAppointment: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var ReceptionistCooment:String!
    
    var specificApp = [] as AnyObject
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
        
        
        let QRcodeURL:String = ex_item1["QRCodeURL"] as! String
        
       
        ReceptionistCooment = ex_item1["ReceptionistComment"] as? String
            
        
        
        specificAppointmentDetails = DetailsAppoinment(AppointmentID: apID, AccCode: accCode, VisFName: fName, VisSName: sName, StaffComp: StaffCompany, StaffNum: SPhone, StaffEmail: SEmail, ExpDate: pectedDate, ExpTime: pectedTime, Duration: Duration, VisReas: reas, Stat: status, QrCode: QRcodeURL, ReceptionistComment:ReceptionistCooment)
        
        
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
                cell.lblContent.backgroundColor = UIColor.orange
            }else if specificAppointmentDetails.Status == "Expired"{
                cell.lblContent.backgroundColor = UIColor.brown
            }else if specificAppointmentDetails.Status == "On Hold"{
                cell.lblContent.backgroundColor = UIColor.yellow
            }else if specificAppointmentDetails.Status == "Scheduled"{
                cell.lblContent.backgroundColor = UIColor.lightGray
            }else if specificAppointmentDetails.Status == "Cancelled"{
                cell.lblContent.backgroundColor = UIColor.red
            }else if specificAppointmentDetails.Status == "Did Not Arrive"{
                cell.lblContent.backgroundColor = UIColor.darkGray
            }else if specificAppointmentDetails.Status == "Tomorrow"{
                cell.lblContent.backgroundColor = UIColor.blue
            }else if specificAppointmentDetails.Status == "Two Days"{
                cell.lblContent.backgroundColor = UIColor.purple
            }else if specificAppointmentDetails.Status == "Did NOt Arrive"{
                cell.lblContent.backgroundColor = UIColor.black
            }else if specificAppointmentDetails.Status == "Expected Duration Elapsed"{
                cell.lblContent.backgroundColor = UIColor.magenta
            }else if specificAppointmentDetails.Status == "Arrived" {
                cell.lblContent.backgroundColor = UIColor.green
            }else if specificAppointmentDetails.Status == "Later"{
                cell.lblContent.backgroundColor = UIColor.cyan
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
