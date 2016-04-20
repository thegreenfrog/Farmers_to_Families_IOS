//
//  FarmerSignUpViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 4/18/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import UIKit

class FarmerSignUpViewController: UIViewController {
    
    var modalListener: ModalFarmerTransitionListener?
    
    var exitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        //maybe gesture slide down to exit?
        exitButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: 75, height: 75)))
        exitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        exitButton.titleLabel!.font = UIFont.systemFontOfSize(24)
        exitButton.setTitle("X", forState: .Normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: "exitPage", forControlEvents: .TouchUpInside)
        self.view.addSubview(exitButton)
        exitButton.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 50).active = true
        exitButton.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor, constant: -12).active = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func exitPage() {
        modalListener?.returnFromModal()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
