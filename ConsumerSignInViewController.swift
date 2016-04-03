//
//  SignInViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 11/8/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit
import Parse

class ConsumerSignInViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets and Variables
    
    struct Constants {
        static let NoEmail = "Please enter your username"
        static let NoPassword = "Please enter your password"
        
        static let textFieldFrame:CGRect = CGRect(origin: CGPointZero, size: CGSize(width: 0, height: 0))
        static let ErrorBorderWidth:CGFloat = 1.0
        static let ErrorMessageProportionHeight:CGFloat = 20.0
        static let ErrorMessageWidth:CGFloat = 200.0
    }
    
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    
    var signInButton: UIButton!
    var signUpButton: UIButton!
    var exitButton: UIButton!
    
    let placeholders = ["Username (email)", "Password"]
    var errorMessages = [String]()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width-10, height: 100)))
        emailTextField.borderStyle = .Line
        emailTextField.tag = 0
        emailTextField.font = UIFont.systemFontOfSize(30)
        emailTextField.returnKeyType = UIReturnKeyType.Done
        emailTextField.text = placeholders[emailTextField.tag]
        emailTextField.textColor = UIColor.lightGrayColor()
        emailTextField.delegate = self
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emailTextField)
        let emailCenterXConstraint = NSLayoutConstraint(item: emailTextField, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let emailLeftConstraint = NSLayoutConstraint(item: emailTextField, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 10)
        let emailCenterYContraint = NSLayoutConstraint(item: emailTextField, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: -100)
        self.view.addConstraint(emailCenterYContraint)
        self.view.addConstraint(emailCenterXConstraint)
        self.view.addConstraint(emailLeftConstraint)
        
        passwordTextField = UITextField(frame: CGRectMake(0, 0, self.view.frame.width-10, 75))
        passwordTextField.borderStyle = .Line
        passwordTextField.tag = 1
        passwordTextField.font = UIFont.systemFontOfSize(30)
        passwordTextField.returnKeyType = UIReturnKeyType.Done
        passwordTextField.text = placeholders[passwordTextField.tag]
        passwordTextField.textColor = UIColor.lightGrayColor()
        passwordTextField.delegate = self
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(passwordTextField)
        let passwordCenterXConstraint = NSLayoutConstraint(item: passwordTextField, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let passwordLeftConstraint = NSLayoutConstraint(item: passwordTextField, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 10)
        let passwordCenterYContraint = NSLayoutConstraint(item: passwordTextField, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: -50)
        self.view.addConstraint(passwordCenterXConstraint)
        self.view.addConstraint(passwordCenterYContraint)
        self.view.addConstraint(passwordLeftConstraint)
        
        signInButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width-10, height: 75)))
        signInButton.setTitle("Sign In", forState: .Normal)
        signInButton.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signInButton)
        let signInCenterXConstraint = NSLayoutConstraint(item: signInButton, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let signInLeftConstraint = NSLayoutConstraint(item: signInButton, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 10)
        let signInCenterYContraint = NSLayoutConstraint(item: signInButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
        self.view.addConstraint(signInCenterXConstraint)
        self.view.addConstraint(signInCenterYContraint)
        self.view.addConstraint(signInLeftConstraint)
        signInButton.addTarget(self, action: "signInAction", forControlEvents: .TouchUpInside)
        
        exitButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: 75, height: 75)))
        exitButton.setTitle("X", forState: .Normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(exitButton)
        let exitCenterXConstraint = NSLayoutConstraint(item: exitButton, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0)
        let exitLeftConstraint = NSLayoutConstraint(item: exitButton, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 30)
        self.view.addConstraint(exitCenterXConstraint)
        self.view.addConstraint(exitLeftConstraint)
        exitButton.addTarget(self, action: "exitPage", forControlEvents: .TouchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    } 
    
    // MARK: - Storyboard UI Functions
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.textColor == UIColor.lightGrayColor() {
            textField.text = nil
            textField.textColor = UIColor.blackColor()
            if textField.tag == 1 {
                textField.secureTextEntry = true
            }
        }
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text!.isEmpty {
            if textField.tag == 1 {
                textField.secureTextEntry = false
            }
            textField.text = placeholders[textField.tag]
            textField.textColor = UIColor.lightGrayColor()
        }
        textField.resignFirstResponder()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    // MARK: - User Actions
    
    func exitPage() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showApplication() {
        
    }
    
    func signInAction(sender: UIButton) {
        emailTextField.layer.borderWidth = 0.0
        passwordTextField.layer.borderWidth = 0.0
        
        if emailTextField.textColor == UIColor.lightGrayColor() {
            errorMessages.append(Constants.NoEmail)
            emailTextField.layer.borderColor = UIColor.redColor().CGColor
            emailTextField.layer.borderWidth = Constants.ErrorBorderWidth
        } else if passwordTextField.textColor == UIColor.lightGrayColor() {
            errorMessages.append(Constants.NoPassword)
            passwordTextField.layer.borderColor = UIColor.redColor().CGColor
            passwordTextField.layer.borderWidth = Constants.ErrorBorderWidth
        }
        
        if(errorMessages.count > 0) {
            handleErrors()
        } else {
            print(passwordTextField.text!)
            PFUser.logInWithUsernameInBackground(emailTextField.text!, password: passwordTextField.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    //seque to main application
                    print("signed in")
                } else {
                    // The login failed
                    if let error = error {
                        self.errorMessages.append(error.localizedDescription)
                        self.handleErrors()
                    }
                }
            }
        }
    }
    
    func handleErrors() {
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: Constants.ErrorMessageWidth, height: Constants.ErrorMessageProportionHeight * CGFloat(errorMessages.count)))
        let errorSubView = UIView(frame: frame)
        errorSubView.center.x = signInButton.center.x
        errorSubView.center.y = signInButton.center.y + Constants.ErrorMessageProportionHeight * CGFloat(errorMessages.count)
        errorSubView.layer.borderColor = UIColor.redColor().CGColor
        errorSubView.layer.borderWidth = Constants.ErrorBorderWidth
        var count = 0
        for error in errorMessages {
            let labelOrigin = CGPoint(x: errorSubView.layer.bounds.origin.x, y: errorSubView.layer.bounds.origin.y + Constants.ErrorMessageProportionHeight * CGFloat(count))
            let errorFrame = CGRect(origin: labelOrigin, size: CGSize(width: Constants.ErrorMessageWidth, height: Constants.ErrorMessageProportionHeight))
            let label = UILabel(frame: errorFrame)
            label.text = error
            label.lineBreakMode = NSLineBreakMode.ByWordWrapping
            label.font = UIFont(name: label.font.fontName, size: 10)
            errorSubView.addSubview(label)
            count++
        }
        self.view.addSubview(errorSubView)
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