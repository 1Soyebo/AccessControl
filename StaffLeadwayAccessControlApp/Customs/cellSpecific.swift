//
//  cellSpecific.swift
//  StaffLeadwayAccessControlApp
//
//  Created by MacUser on 9/9/19.
//  Copyright © 2019 MacUser. All rights reserved.
//

import UIKit

class cellSpecific: UITableViewCell {

    @IBOutlet weak var lblDisplayName: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblContent.layer.cornerRadius = 8.0
        lblContent.clipsToBounds = true
        
        self.backgroundColor = UIColor.clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
