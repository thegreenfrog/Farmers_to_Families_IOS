//
//  GroceryBagTableViewCell.swift
//  LocalFarming
//
//  Created by Chris Lu on 12/16/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit

class GroceryBagTableViewCell: UITableViewCell {

    var priceLabel: UILabel!
    var produceCountLabel: UILabel!
    var farmNameLabel: UILabel!
    var produceNameLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //see everlane checkout page
        let imageView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 50, height: 50)))
        imageView.layer.borderColor = Colors.woodColor.CGColor
        imageView.layer.borderWidth = 2.0
        imageView.layer.shadowColor = UIColor.blackColor().CGColor
        imageView.layer.shadowOffset = CGSizeMake(0, 1)
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowRadius = 2.0
        imageView.clipsToBounds = false
        imageView.image = UIImage(named: "produce_placeholder.jpg")
        
        produceNameLabel = UILabel()
        produceNameLabel.font = UIFont.systemFontOfSize(10.0)
        farmNameLabel = UILabel()
        farmNameLabel.font = UIFont.systemFontOfSize(10.0)
        priceLabel = UILabel()
        priceLabel.font = UIFont.systemFontOfSize(10.0)
        let subStackView = UIStackView()
        subStackView.axis = .Vertical
        subStackView.addArrangedSubview(produceNameLabel)
        subStackView.addArrangedSubview(farmNameLabel)
        subStackView.addArrangedSubview(priceLabel)
        
        produceCountLabel = UILabel()
        let wholeStackView = UIStackView()
        wholeStackView.axis = .Horizontal
        wholeStackView.addArrangedSubview(imageView)
        wholeStackView.addArrangedSubview(subStackView)
        wholeStackView.addArrangedSubview(produceCountLabel)
        self.addSubview(wholeStackView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
