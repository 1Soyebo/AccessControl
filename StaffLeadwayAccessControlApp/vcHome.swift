//
//  vcHome.swift
//  StaffLeadwayAccessControlApp
//
//  Created by MacUser on 9/4/19.
//  Copyright © 2019 MacUser. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class vcHome: UIViewController {

    
    @IBOutlet weak var btnCreateAppointment: UIButton!
    @IBOutlet weak var btnAllAppointments: UIButton!
    
    @IBOutlet weak var btnToday: UIButton!
    @IBOutlet weak var btnQrCode: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Group")!)
        btnAllAppointments.layer.cornerRadius = 8.0
        btnAllAppointments.clipsToBounds = true
        
        btnCreateAppointment.layer.cornerRadius = 8.0
        btnCreateAppointment.clipsToBounds = true

        btnToday.layer.cornerRadius = 8.0
        btnToday.clipsToBounds = true

        btnQrCode.layer.cornerRadius = 8.0
        btnQrCode.clipsToBounds = true

        // Do any additional setup after loading the view.
    }


    
    @IBAction func btnCreateVisitor(_ sender: Any) {
        let pushCreateVisitor = vcCreateVisitor(nibName:"vcCreateVisitor", bundle:nil)
        navigationController?.pushViewController(pushCreateVisitor, animated: true)
    }
    
    
    @IBAction func btnLogout(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Login") as! ViewController
        
        
        let alertCont = UIAlertController(title: "Log Out", message:"Do You Want To Log Out", preferredStyle: .alert)
        let yesAction =  UIAlertAction(title: "Confirm", style: .default, handler: ({Void in
            
            UserDefaults.standard.set(false, forKey: "LoggedStatus")
            //tabBarController!.selectedViewController = controller
            self.present(controller, animated: true, completion: nil)
            controller.AlertToAddPin()
        }))
        
        let noAction = UIAlertAction(title: "No", style: .destructive, handler: ({Void in}))
        
        alertCont.addAction(yesAction)
        alertCont.addAction(noAction)
        self.present(alertCont, animated: true, completion: nil)
        //controller.loggedStat = false
        
        //navigationController?.popToRootViewController(animated: true)
        //UserDefaults.standard.bool(forKey: "LoggedStatus")
    }
    
    
    
    
    
    
    
    @IBAction func pushToHistory(_ sender: Any) {
//        let tabBarController = UIApplication.shared.keyWindow?.rootViewController?.tag
//        tabBarController.selectedIndex = 1
//        self.presentingViewController!.presentingViewController!.dismiss(animated: true, completion: {})
        let pushCreateVisitor = vcRecallVisitor(nibName:"vcRecallVisitor", bundle:nil)
        tabBarController?.selectedViewController?.navigationController?.pushViewController(pushCreateVisitor, animated: true)
        
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
