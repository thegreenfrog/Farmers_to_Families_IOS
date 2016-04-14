//
//  ConsumerRegisterViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 3/31/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import UIKit

class ConsumerRegisterViewController: UIViewController {
    
    struct Constants {
        static let buttonFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 45))
        static let labelFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 225, height: 100))
    }
    
    var signInButton: UIButton!
    var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.lightBrown
        signInButton = UIButton(frame: Constants.buttonFrame)
        signInButton.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
        signInButton.setTitle("Sign In", forState: .Normal)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self, action: "showSignIn", forControlEvents: .TouchUpInside)
        
        signUpButton = UIButton(frame: Constants.buttonFrame)
        signUpButton.backgroundColor = UIColor.clearColor()
        signUpButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        signUpButton.setTitle("Sign Up", forState: .Normal)
        signUpButton.layer.masksToBounds = true
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: "showSignUp", forControlEvents: .TouchUpInside)

        let screenStackView = UIStackView()
        screenStackView.addArrangedSubview(signInButton)
        screenStackView.addArrangedSubview(signUpButton)
        screenStackView.axis = .Vertical
        screenStackView.alignment = .Fill
        screenStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(screenStackView)
        screenStackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        screenStackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: 25).active = true
        screenStackView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.5).active = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showSignIn() {
        let signInVC = ConsumerSignInViewController()
        signInVC.modalTransitionStyle = .CoverVertical
        presentViewController(signInVC, animated: true, completion: nil)
    }
    
    func showSignUp() {
        let signUpVC = ConsumerSignUpViewController()
        signUpVC.modalTransitionStyle = .CoverVertical
        presentViewController(signUpVC, animated: true, completion: nil)
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
