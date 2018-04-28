//
//  ActivityCellTwoTableViewCell.swift
//  SmartCykulApplication
//
//  Created by MAC BOOK on 17/04/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit

class ActivityCellTwoTableViewCell: UITableViewCell {

    @IBOutlet weak var CycleTwoLbl: UILabel!
    
    
    @IBOutlet weak var StatusLbl2: UILabel!
    
    
    @IBOutlet weak var Fare2Lbl: UILabel!
    
    
    @IBOutlet weak var DateTime2Lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
