//
//  FarmCell.swift
//  LocalFarming
//
//  Created by Chris Lu on 4/3/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import Foundation
import UIKit

class FarmCell: UITableViewCell {
    var nameLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        nameLabel = UILabel(frame: CGRectZero)
        nameLabel.numberOfLines = 0
        contentView.addSubview(nameLabel)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        nameLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
}