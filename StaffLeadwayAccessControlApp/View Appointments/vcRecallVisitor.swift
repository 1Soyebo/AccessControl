//
//  vcRecallVisitor.swift
//  StaffLeadwayAccessControlApp
//
//  Created by MacUser on 9/5/19.
//  Copyright © 2019 MacUser. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Floaty

class vcRecallVisitor: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    var convertedDate:String = ""
    var convertedTime:String = ""
    
    
    
        
    let staffID:Int =  UserDefaults.standard.integer(forKey: "loggedStaffID")
    var IDapp:Int = 0
    var pp:[Appointment] = []
    var searchresult:[Appointment] = []
    
    var specificApp = [] as AnyObject
    
    var ListFOAppointments = [] as AnyObject
    var listAppoinments:Any = [] as Any
    
    var isSearching = false
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imgAdd: UIButton!
    @IBOutlet weak var tblAllAppoitnments: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        
        let floatty = Floaty()
        floatty.plusColor = UIColor.white
        floatty.buttonColor = UIColor.init(red: 234.0/255.0, green: 91.0/255.0, blue: 12.0/255.0, alpha: 1)
        floatty.addItem("Create Appointmment", icon: UIImage(named: "add")!, handler: { item in self.moveToCreateAppointment()})
        floatty.paddingY += tabBarController!.tabBar.frame.size.height
        self.view.addSubview(floatty)
        
        
        //setupButton()
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        tblAllAppoitnments.refreshControl = refresh

        //tblAllAppoitnments.backgroundView = UIImageView(image: UIImage(named: "Group"))
        tblAllAppoitnments.tableFooterView = UIView()
        
        GetAppointments()
        let nib = UINib.init(nibName: "cellAppointment", bundle:nil)
        self.tblAllAppoitnments.register(nib, forCellReuseIdentifier: "cellAppointment")

        
        self.title = "Appointments"
        
//        imgAdd.contentMode = .scaleAspectFit
//        imgAdd.layer.cornerRadius = imgAdd.frame.height / 2
        tblAllAppoitnments.reloadData()
       
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    func moveToCreateAppointment(){
        let koll = vcCreateVisitor(nibName:"vcCreateVisitor", bundle:nil)
        navigationController?.pushViewController(koll, animated: true)
    }
    
    
    @IBAction func refreshTable(){
        GetAppointments()
    }
    
    @objc func refresh(){
        refreshTable()
        tblAllAppoitnments.refreshControl?.endRefreshing()
    }
    
    func GetAppointments(){
        SVProgressHUD.show()
        let todoEndpoint: String = "http://dynamics.somee.com/api/Staff/SearchVisitor/\(staffID)?"
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
                //print(json)
                if(status){
                    
                    self.ListFOAppointments = json["data"] as AnyObject
                    self.listAppoinments = self.ListFOAppointments
                    self.pp = []
                    self.addAppointmentToClass()
                    SVProgressHUD.dismiss()
                    self.tblAllAppoitnments.reloadData()
                    
                    
                    
                    
                }
                else{
                    print("Error")
                }
                
        }

    }
    
    func addAppointmentToClass(){
        let d = self.listAppoinments as! Array<[String: Any]>
        print(self.listAppoinments)
        
        for item in d{
            
            let appID: Int = item["AppointmentID"] as! Int
            let Fname: String = item["FirstName"] as! String
            let Sname: String = item["Surname"] as! String
            let comName: String = item["VisitorCompany"] as! String
            //let AccCode:String = item["AccessCode"] as! String
            let date: String = item["ExpectedDate"] as! String
            let time:String = item["ExpectedTime"] as! String
            //let stat:String = item["OverallStatus"] as! String
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "MMM-d"
            
            let dateComponents = date.components(separatedBy: "T")
            let splitDate = dateComponents[0]
            
            if let datum = dateFormatter.date(from: splitDate){
                convertedDate = newDateFormatter.string(from: datum)
            }
            
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH-mm-ss"
            let newTimeFormatter = DateFormatter()
            newTimeFormatter.dateFormat = "h:mm a"
            
            if let timen = timeFormatter.date(from: time){
                convertedTime = newTimeFormatter.string(from: timen)
            }
            
            let appoint = Appointment(AppoinmentID: appID, visFname: Fname, visSName: Sname, CompanyName: comName, accessCode: "", Date: convertedDate, time: convertedTime, Status: "")
            pp.append(appoint)
            print(pp)
        }

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return searchresult.count
        }else if pp.isEmpty{
            return 1
        }else {
            return pp.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAppointment") as! cellAppointment
        
        if isSearching
        {
            let index = searchresult[indexPath.row]
            cell.lblVisitorName.text = index.visSName! + " " + index.visFName!
            cell.lblExpectedDate.text = index.Date
            cell.lblExpectedTime.text = index.Time
            cell.lblReason.text = index.CompanyName
            
            
            
        if searchresult.isEmpty{
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = "No Search Result"
            return cell
            
            }
            
            return cell
        }
        else if pp.isEmpty
        {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = "No Appointments Created"
            return cell
        
        }
        else
        {
            
            let index = pp[indexPath.row]
            cell.lblVisitorName.text = index.visSName! + " " + index.visFName!
            cell.lblExpectedDate.text = index.Date
            cell.lblExpectedTime.text = index.Time
            cell.lblReason.text = index.CompanyName
            
            
            
            return cell
            
        }
        
        //return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblAllAppoitnments.deselectRow(at: indexPath, animated: true)
        if isSearching{
            
            self.IDapp = searchresult[indexPath.row].AppointmentID!
            //tblAllAppoitnments.deselectRow(at: indexPath, animated: true)
            SVProgressHUD.show()
            let todoEndpoint: String = "http://dynamics.somee.com/api/Visitor/ViewReceptionistAppointment/\(IDapp)"
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
                        let push = vcTodayAppointment(nibName:"vcTodayAppointment", bundle:nil)
                        push.specAppoint = self.specificApp
                        SVProgressHUD.dismiss()
                        self.navigationController?.pushViewController(push, animated: true)
                    }
                    else{
                        print("Error")
                    }
                    
            }

        }else if pp.isEmpty
        {
            //tblAllAppoitnments.deselectRow(at: indexPath, animated: true)
        print("No appointments")
        }else{
            self.IDapp = pp[indexPath.row].AppointmentID!
            //tblAllAppoitnments.deselectRow(at: indexPath, animated: true)
            SVProgressHUD.show()
            let todoEndpoint: String = "http://dynamics.somee.com/api/Visitor/ViewReceptionistAppointment/\(IDapp)"
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
                        self.specificApp = json["pointments"] as AnyObject
                        let push = vcTodayAppointment(nibName:"vcTodayAppointment", bundle:nil)
                        push.specAppoint = self.specificApp
                        SVProgressHUD.dismiss()
                        self.navigationController?.pushViewController(push, animated: true)
                    }
                    else{
                        print("Error")
                    }
                    
            }

        }
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchresult = pp.filter({$0.AccessCode!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.CompanyName!.lowercased().prefix(searchText.count) ==
            searchText.lowercased() || $0.Date!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.visFName!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.visSName!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.Time!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.Status!.lowercased().prefix(searchText.count) == searchText.lowercased()})
        self.isSearching = true
        tblAllAppoitnments.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        tblAllAppoitnments.reloadData()
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
