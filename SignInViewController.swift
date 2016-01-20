//
//  SignInViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 11/8/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit
import Parse

class SignInViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets and Variables
    
    struct Constants {
        static let NoEmail = "Please enter your username"
        static let NoPassword = "Please enter your password"
        
        static let ErrorBorderWidth:CGFloat = 1.0
        static let ErrorMessageProportionHeight:CGFloat = 20.0
        static let ErrorMessageWidth:CGFloat = 200.0
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    let placeholders = ["Username (email)", "Password"]
    var errorMessages = [String]()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.tag = 0
        emailTextField.text = placeholders[emailTextField.tag]
        emailTextField.textColor = UIColor.lightGrayColor()
        emailTextField.delegate = self
        passwordTextField.tag = 1
        passwordTextField.text = placeholders[passwordTextField.tag]
        passwordTextField.textColor = UIColor.lightGrayColor()
        passwordTextField.delegate = self
        
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
    
    @IBAction func signUpButton(sender: UIButton) {
        performSegueWithIdentifier("signUpModal", sender: self)
    }
    
    @IBAction func signInButton(sender: UIButton) {
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
                    self.performSegueWithIdentifier("cancelFromSignIn", sender: self)
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
        errorSubView.center.x = signUpButton.center.x
        errorSubView.center.y = signUpButton.center.y + Constants.ErrorMessageProportionHeight * CGFloat(errorMessages.count)
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
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        performSegueWithIdentifier("cancelFromSignIn", sender: self)
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
