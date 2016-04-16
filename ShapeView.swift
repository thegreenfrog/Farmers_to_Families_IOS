//
//  ShapeView.swift
//  LocalFarming
//
//  Created by Chris Lu on 4/15/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import UIKit

class ShapeView: UIView {
    var begin: CGPoint = CGPointZero
    
    init(start: CGPoint) {
        super.init(frame: CGRectZero)
        begin = start
        self.center = start
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let leftArrowPath = UIBezierPath()
        let start = begin
        leftArrowPath.moveToPoint(start)
        var next = CGPoint(x: start.x-25, y: start.y-20)
        leftArrowPath.addLineToPoint(next)
        next = CGPoint(x: next.x, y: next.y+10)
        leftArrowPath.addLineToPoint(next)
        next = CGPoint(x: next.x-50, y: next.y)
        leftArrowPath.addLineToPoint(next)
        next = CGPoint(x: next.x, y: next.y+20)
        leftArrowPath.addLineToPoint(next)
        next = CGPoint(x: next.x+50, y: next.y)
        leftArrowPath.addLineToPoint(next)
        next = CGPoint(x: next.x, y: next.y+10)
        leftArrowPath.addLineToPoint(next)
        next = begin
        leftArrowPath.addLineToPoint(begin)
        leftArrowPath.closePath()
        leftArrowPath.stroke()
    }

}
