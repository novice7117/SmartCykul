//
//  HeaderTableViewCell.swift
//  SmartCykulApplication
//
//  Created by MAC BOOK on 14/04/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell
{
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
