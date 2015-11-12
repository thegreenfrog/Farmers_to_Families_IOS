//
//  ProfileViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 11/10/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    struct Constants {
        static let signInUpHeight: CGFloat = 25
        static let signInUpWidth: CGFloat = 80
        static let signInTitle = "Sign In"
        static let signUpTitle = "Sign Up"
        static let cornerRadius: CGFloat = 2.5
        static let signInVerticalSpacingFromCenter:CGFloat = 20
        
        static let signUpSegueID = "signUpPage"
        static let signInSegueID = "signInModal"
        static let notSignedInTitle = "Your Profile"
        static let signIn = "Sign In"
        static let logOut = "Log Out"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if PFUser.currentUser() != nil {
            if let first = PFUser.currentUser()!["firstName"] as? String, last = PFUser.currentUser()!["lastName"] as? String {
                self.title = first + last
            }

        } else {
            self.title = Constants.notSignedInTitle

            signIn()
            //sign-in & sign-up button shows up
//            let signInButton = UIButton()
//            signInButton.setTitle(Constants.signInTitle, forState: .Normal)
//            signInButton.frame = CGRect(origin: CGPointZero, size: CGSize(width: Constants.signInUpWidth, height: Constants.signInUpHeight))
//            signInButton.frame.origin.x = self.view.frame.size.width / 2
//            signInButton.frame.origin.y = (self.view.frame.height / 2) - Constants.signInVerticalSpacingFromCenter
//            signInButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//            signInButton.backgroundColor = UIColor.blueColor()
//            signInButton.layer.cornerRadius = Constants.cornerRadius
//            signInButton.addTarget(self, action: "signIn", forControlEvents: .TouchUpInside)
//            self.view.addSubview(signInButton)
            
//                        let signUpButton = UIButton()
//                        signUpButton.setTitle(Constants.signUpTitle, forState: .Normal)
//                        signUpButton.frame = CGRect(origin: CGPointZero, size: CGSize(width: Constants.signInUpWidth, height: Constants.signInUpHeight))
//                        signUpButton.frame.origin.x = self.view.bounds.midX
//                        signUpButton.frame.origin.y = self.view.bounds.midY + Constants.signInVerticalSpacingFromCenter
//                        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//                        signUpButton.backgroundColor = UIColor.blueColor()
//                        signUpButton.layer.cornerRadius = Constants.cornerRadius
//                        signUpButton.addTarget(self, action: "signUp", forControlEvents: .TouchUpInside)
//                        self.view.addSubview(signUpButton)
            
        }
        // Do any additional setup after loading the view.
    }
    
    func signIn() {
        performSegueWithIdentifier(Constants.signInSegueID, sender: self)
    }
    
    //unwind function from sign-in and sign-up page
    @IBAction func unwindToProfile(segue: UIStoryboardSegue) {
        
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
