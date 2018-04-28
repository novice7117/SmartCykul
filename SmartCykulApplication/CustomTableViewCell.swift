//
//  CustomTableViewCell.swift
//  SmartCykul
//
//  Created by Cykul Cykul on 01/02/18.
//  Copyright © 2018 Cykul Cykul. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var customImgView: UIImageView!
    
    @IBOutlet weak var customLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
