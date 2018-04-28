//
//  ActivityCellOneTableViewCell.swift
//  SmartCykulApplication
//
//  Created by MAC BOOK on 17/04/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit

class ActivityCellOneTableViewCell: UITableViewCell {

    @IBOutlet weak var CellCycleNO: UILabel!
    
    @IBOutlet weak var StatusLbl: UILabel!
    
    @IBOutlet weak var FareLbl: UILabel!
    
    @IBOutlet weak var DateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
