//
//  vcLaunchScreen.swift
//  StaffLeadwayAccessControlApp
//
//  Created by MacUser on 9/6/19.
//  Copyright © 2019 MacUser. All rights reserved.
//

import UIKit

class vcLaunchScreen: UIViewController {
    
    var LoggedState:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoggedState = UserDefaults.standard.bool(forKey: "LoggedStatus")
        
        // Do any additional setup after loading the view.
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
