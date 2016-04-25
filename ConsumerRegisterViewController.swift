//
//  ConsumerRegisterViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 3/31/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import UIKit

protocol ModalConsumerTransitionListener {
    func returnFromModal(registered: Bool)
    func goToApp()
}

class ConsumerRegisterViewController: UIViewController, ModalConsumerTransitionListener, UIViewControllerTransitioningDelegate {
    
    struct Constants {
        static let buttonFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 45))
        static let labelFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 225, height: 100))
    }
    
    var signInButton: UIButton!
    var signUpButton: UIButton!
    
    let transition = VCAnimator()
    
    var signInVC: ConsumerSignInViewController?
    var signUpVC: ConsumerSignUpViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        signInButton = UIButton(frame: Constants.buttonFrame)
        signInButton.backgroundColor = UIColor.clearColor()
        signInButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signInButton.setTitle("Sign In", forState: .Normal)
        signInButton.layer.borderColor = UIColor.whiteColor().CGColor
        signInButton.layer.borderWidth = 1.0
        signInButton.titleLabel?.font = UIFont.systemFontOfSize(24)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self, action: "showSignIn", forControlEvents: .TouchUpInside)
        
        signUpButton = UIButton(frame: Constants.buttonFrame)
        signUpButton.backgroundColor = UIColor.clearColor()
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signUpButton.setTitle("Join Now", forState: .Normal)
        signUpButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        signUpButton.layer.masksToBounds = true
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: "showSignUp", forControlEvents: .TouchUpInside)

        let screenStackView = UIStackView()
        screenStackView.addArrangedSubview(signInButton)
        screenStackView.addArrangedSubview(signUpButton)
        screenStackView.axis = .Vertical
        screenStackView.alignment = .Fill
        screenStackView.spacing = 10
        screenStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(screenStackView)
        screenStackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        screenStackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        screenStackView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.5).active = true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showSignIn() {
        signInVC = ConsumerSignInViewController()
        signInVC!.modalListener = self
        signInVC!.modalTransitionStyle = .CoverVertical
        signInVC!.modalPresentationStyle = .OverCurrentContext
        signInButton.hidden = true
        signUpButton.hidden = true
        presentViewController(signInVC!, animated: true, completion: nil)
    }
    
    func showSignUp() {
        signUpVC = ConsumerSignUpViewController()
        signUpVC!.modalListener = self
        signUpVC!.modalTransitionStyle = .CoverVertical
        signUpVC!.modalPresentationStyle = .OverCurrentContext
        signUpVC?.transitioningDelegate = self
        signInButton.hidden = true
        signUpButton.hidden = true
        
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
        tabBarVC.transitioningDelegate = self
        self.presentViewController(tabBarVC, animated: true, completion: nil)
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

extension ConsumerRegisterViewController {
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            return transition
    }
}
