//
//  AppointmentList.swift
//  StaffLeadwayAccessControlApp
//
//  Created by MacUser on 9/7/19.
//  Copyright © 2019 MacUser. All rights reserved.
//

import Foundation
import UIKit

class Appointment{
    
    var AppointmentID:Int?
    var visFName:String?
    var visSName:String?
    var CompanyName:String?
    var AccessCode:String?
    
    var Date:String?
    var Time:String?
    var Status:String?
    
    
    init(AppoinmentID:Int, visFname:String, visSName:String, CompanyName:String, accessCode:String, Date:String, time:String, Status:String) {
        self.AppointmentID = AppoinmentID
        self.visFName = visFname
        self.visSName = visSName
        self.CompanyName = CompanyName
        self.AccessCode = accessCode
        self.Date = Date
        self.Time = time
        self.Status = Status
    }
    
}
