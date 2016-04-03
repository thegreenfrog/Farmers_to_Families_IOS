//
//  RegisterViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 3/31/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    struct Constants {
        static let buttonFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 45))
        static let labelFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 225, height: 100))
    }
    var farmerButton: UIButton!
    var consumerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "brown-bag.jpg")!)
        
        let welcomeLabel = UILabel(frame: Constants.buttonFrame)
        welcomeLabel.backgroundColor = UIColor.brownColor()
        welcomeLabel.numberOfLines = 0
        welcomeLabel.text = "Welcome! Register as:"
        welcomeLabel.textAlignment = .Center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(welcomeLabel)
        let welcomeXConstraint = NSLayoutConstraint(item: welcomeLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let welcomeYConstraint = NSLayoutConstraint(item: welcomeLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: -60)
        self.view.addConstraint(welcomeXConstraint)
        self.view.addConstraint(welcomeYConstraint)
        
        
        farmerButton = UIButton(frame: Constants.buttonFrame)
        farmerButton.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
        farmerButton.setTitle("Farmer", forState: .Normal)
        farmerButton.layer.masksToBounds = true
        farmerButton.layer.cornerRadius = 15
        farmerButton.addTarget(self, action: "segueToFarmerSignin", forControlEvents: .TouchUpInside)
        farmerButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(farmerButton)
        let farmerXConstraint = NSLayoutConstraint(item: farmerButton, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let farmerYConstraint = NSLayoutConstraint(item: farmerButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 40)
        self.view.addConstraint(farmerXConstraint)
        self.view.addConstraint(farmerYConstraint)
        
        consumerButton = UIButton(frame: Constants.buttonFrame)
        consumerButton.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
        consumerButton.setTitle("Shopper", forState: .Normal)
        consumerButton.layer.masksToBounds = true
        consumerButton.layer.cornerRadius = 15
        consumerButton.addTarget(self, action: "segueToShopperSignin", forControlEvents: .TouchUpInside)
        consumerButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(consumerButton)
        let consumerXConstraint = NSLayoutConstraint(item: consumerButton, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let consumerYConstraint = NSLayoutConstraint(item: consumerButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 100)
        self.view.addConstraint(consumerXConstraint)
        self.view.addConstraint(consumerYConstraint)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segueToFarmerSignin() {
        
    }
    
    func segueToShopperSignin() {
        let consumerInVC = ConsumerRegisterViewController()
        presentViewController(consumerInVC, animated: true, completion: nil)
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
