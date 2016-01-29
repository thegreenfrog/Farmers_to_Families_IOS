//
//  NotificationsTableViewCell.swift
//  LocalFarming
//
//  Created by Chris Lu on 1/26/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import UIKit

protocol goToOutBidProduceDelegate {
    func jumpToProduceVC(row: Int)
}

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var row: Int?
    var delegate: goToOutBidProduceDelegate?
    
    @IBAction func viewProduce(sender: UIButton) {
        delegate?.jumpToProduceVC(row!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
