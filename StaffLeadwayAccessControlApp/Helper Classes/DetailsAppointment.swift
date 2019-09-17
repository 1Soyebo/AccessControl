//
//  DetailsAppointment.swift
//  StaffLeadwayAccessControlApp
//
//  Created by MacUser on 9/8/19.
//  Copyright © 2019 MacUser. All rights reserved.
//

import Foundation

class Appoinments: Codable{
    let Appoinments:[DetailsAppoinment]
    init(Appoinments: [DetailsAppoinment]){
        self.Appoinments = Appoinments
    }
}


class DetailsAppoinment:Codable
{
    
    var AppoinmentID:Int?
    var AccessCode:String?
    
    var VisFirstName:String?
    var VisSurName:String?
    
    var StaffCompany:String?
    var StaffPhone:String?
    
    var StaffEmail:String?
    
    var ExpectedDate:String?
    var ExpectedTime:String
    
    var Duration:String?
    var VisReason:String?
    
    var Status:String?
    
    var QRCodeURL:String?
    var ReceptionistComment:String!
    
    init(AppointmentID:Int, AccCode:String, VisFName:String, VisSName:String, StaffComp:String, StaffNum:String, StaffEmail:String, ExpDate:String, ExpTime:String, Duration:String, VisReas:String, Stat:String, QrCode:String, ReceptionistComment:String) {
        
        self.AppoinmentID = AppointmentID
        self.AccessCode = AccCode
        self.VisFirstName = VisFName
        self.VisSurName = VisSName
        self.StaffCompany = StaffComp
        self.StaffPhone = StaffNum
        self.StaffEmail = StaffEmail
        self.ExpectedDate = ExpDate
        self.ExpectedTime = ExpTime
        self.Duration = Duration
        self.VisReason = VisReas
        self.Status = Stat
        self.QRCodeURL = QrCode
        self.ReceptionistComment = ReceptionistComment
        
        
        
    }
}
