//
//  ProduceTableViewCell.swift
//  LocalFarming
//
//  Created by Chris Lu on 12/9/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit

protocol ChangingPurchaseQueueDelegate {
    func updatePurchaseCount(index: Int, newValue: Int)
}

class ProduceTableViewCell: UITableViewCell {

    @IBAction func ChangeTotal(sender: UIStepper) {
        delegate!.updatePurchaseCount(rowNum!, newValue: Int(sender.value))

    }
    
    var rowNum: Int?
    @IBOutlet weak var ProduceName: UILabel!
    @IBOutlet weak var Price: UILabel!
    
    var delegate: ChangingPurchaseQueueDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
