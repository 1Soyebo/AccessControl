//
//  City.swift
//  StaffLeadwayAccessControlApp
//
//  Created by MacUser on 9/6/19.
//  Copyright © 2019 MacUser. All rights reserved.
//

import Foundation

class Cities: Codable{
    let Citys:[City]
    init(Citys: [City]){
        self.Citys = Citys
    }
}


class City: Codable{
    
    let CityID:Int?
    let CityName:String?
    
    
    init(CityID:Int, CityName:String){
        self.CityID = CityID
        self.CityName = CityName
        
    }
    
    
    
}
