//
//  States.swift
//  StaffLeadwayAccessControlApp
//
//  Created by MacUser on 9/6/19.
//  Copyright © 2019 MacUser. All rights reserved.
//

import Foundation

class States: Codable{
    let States:[State]
    init(states: [State]){
        self.States = states
    }
}

class State: Codable {
    
    let StateCode:String?
    let StateName:String?
    let StateID:Int?
    
    init(stateCode: String, stateName: String, stateID: Int){
        self.StateCode = stateCode
        self.StateName = stateName
        self.StateID = stateID
        
    }
    
    
}
