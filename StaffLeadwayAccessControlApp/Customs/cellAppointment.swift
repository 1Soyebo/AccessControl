//
//  cellAppointment.swift
//  StaffLeadwayAccessControlApp
//
//  Created by MacUser on 9/7/19.
//  Copyright © 2019 MacUser. All rights reserved.
//

import UIKit

class cellAppointment: UITableViewCell {

    @IBOutlet weak var lblVisitorName: UILabel!
    @IBOutlet weak var lblExpectedDate: UILabel!
    @IBOutlet weak var lblExpectedTime: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblVisitorName.sizeToFit()
        lblExpectedTime.sizeToFit()
        lblReason.sizeToFit()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
