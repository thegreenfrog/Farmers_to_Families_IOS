//
//  FarmerRegisterViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 4/13/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import UIKit

protocol ModalFarmerTransitionListener {
    func returnFromModal(registered: Bool)
    func goToApp()
}

class FarmerRegisterViewController: UIViewController, ModalFarmerTransitionListener {
    
    struct Constants {
        static let buttonFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 45))
        static let labelFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 225, height: 100))
    }

    var signInButton: UIButton!
    var signUpButton: UIButton!
    
    var signInVC: FarmerSignInViewController?
    var signUpVC: FarmerSignUpViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        
        signInButton = UIButton(frame: Constants.buttonFrame)
        signInButton.backgroundColor = UIColor.clearColor()
        signInButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signInButton.titleLabel?.font = UIFont.systemFontOfSize(24)
        signInButton.layer.borderColor = UIColor.whiteColor().CGColor
        signInButton.layer.borderWidth = 1.0
        signInButton.setTitle("Sign In", forState: .Normal)
        signInButton.layer.masksToBounds = true
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self, action: "showSignIn", forControlEvents: .TouchUpInside)
        
        signUpButton = UIButton(frame: Constants.buttonFrame)
        signUpButton.backgroundColor = UIColor.clearColor()
        signUpButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
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
        signInVC = FarmerSignInViewController()
        signInVC!.modalTransitionStyle = .CoverVertical
        signInVC!.modalPresentationStyle = .OverCurrentContext
        signInVC!.modalListener = self
        signUpButton.hidden = true
        signInButton.hidden = true
        presentViewController(signInVC!, animated: true, completion: nil)
    }
    
    func showSignUp() {
        signUpVC = FarmerSignUpViewController()
        signUpVC!.modalTransitionStyle = .CoverVertical
        signUpVC!.modalPresentationStyle = .OverCurrentContext
        signUpVC!.modalListener = self
        signUpButton.hidden = true
        signInButton.hidden = true
        presentViewController(signUpVC!, animated: true, completion: nil)
    }

    func returnFromModal(registered: Bool) {
        if(registered) {
            //show spinning wheel
            let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            loadingIndicator.userInteractionEnabled = false
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            loadingIndicator.startAnimating()
            self.view.addSubview(loadingIndicator)
            loadingIndicator.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
            loadingIndicator.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
            
            
        } else {
            signInButton.hidden = false
            signUpButton.hidden = false
        }
        
    }
    
    func goToApp() {
        //seque to main application
        let tabBarVC = ConsumerTabBarController()
        self.presentViewController(tabBarVC, animated: true, completion: nil)
    }
}
