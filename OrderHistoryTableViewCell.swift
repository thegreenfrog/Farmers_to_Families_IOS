//
//  OrderHistoryTableViewCell.swift
//  LocalFarming
//
//  Created by Chris Lu on 1/1/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var produceLabel: UILabel!
    @IBOutlet weak var farmLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
