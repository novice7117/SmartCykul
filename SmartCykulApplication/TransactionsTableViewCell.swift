//
//  TransactionsTableViewCell.swift
//  SmartCykulApplication
//
//  Created by MAC BOOK on 14/04/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {

    @IBOutlet weak var TransactionView: UIView!
    @IBOutlet weak var paymentPurposeLBL: UILabel!
    @IBOutlet weak var PaymentAmountLBL: UILabel!
    @IBOutlet weak var PaymentDateLBL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
