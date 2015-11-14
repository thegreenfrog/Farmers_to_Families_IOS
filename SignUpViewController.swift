//
//  SignUpViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 11/8/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Constants and Variables

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePassTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    struct Constants {
        static let NoFirstName = "Please enter your first name"
        static let NoLastName = "Please enter your last name"
        static let Noemail = "Please enter your email address"
        static let NoPassword = "Please enter a password with at least 6 characters"
        static let NoretypePassword = "Please re-enter the same password"
        
        static let EmailRegex = "[^@]+[@][a-z0-9]+[.][a-z]*"
        
        static let ErrorBorderWidth:CGFloat = 1.0
        static let ErrorMessageProportionHeight:CGFloat = 20.0
        static let ErrorMessageWidth:CGFloat = 200.0
    }
    
    let placeholders = ["First Name","Last Name", "Email Address", "Enter Password (at least 6 characters)", "re-Enter Password"]
    var errorMessages = [String]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.tag = 0
        lastNameTextField.tag = 1
        emailTextField.tag = 2
        passwordTextField.tag = 3
        retypePassTextField.tag = 4
        firstNameTextField.text = placeholders[firstNameTextField.tag]
        lastNameTextField.text = placeholders[lastNameTextField.tag]
        emailTextField.text = placeholders[emailTextField.tag]
        passwordTextField.text = placeholders[passwordTextField.tag]
        retypePassTextField.text = placeholders[retypePassTextField.tag]
        firstNameTextField.textColor = UIColor.lightGrayColor()
        lastNameTextField.textColor = UIColor.lightGrayColor()
        emailTextField.textColor = UIColor.lightGrayColor()
        passwordTextField.textColor = UIColor.lightGrayColor()
        retypePassTextField.textColor = UIColor.lightGrayColor()
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.retypePassTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Storyboard UI Functions
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.textColor == UIColor.lightGrayColor() {
            textField.text = nil
            textField.textColor = UIColor.blackColor()
        }
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text!.isEmpty {
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
    
    @IBAction func dismissAttempt(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signupButton(sender: UIButton) {
        //make sure inputs are filled in properly
        if firstNameTextField.textColor == UIColor.lightGrayColor() {
            errorMessages.append(Constants.NoFirstName)
            highlightTextField(firstNameTextField)
        }
        if lastNameTextField.textColor == UIColor.lightGrayColor() {
            errorMessages.append(Constants.NoLastName)
            highlightTextField(lastNameTextField)
        }
        if emailTextField.textColor == UIColor.lightGrayColor() || emailTextField.text?.rangeOfString(Constants.EmailRegex, options: .RegularExpressionSearch) == nil {
            errorMessages.append(Constants.Noemail)
            highlightTextField(emailTextField)
        }
        if passwordTextField.textColor == UIColor.lightGrayColor() || passwordTextField.text!.characters.count < 6 {
            errorMessages.append(Constants.NoPassword)
            highlightTextField(passwordTextField)
        }
        if retypePassTextField.textColor == UIColor.lightGrayColor() || retypePassTextField.text!.characters.count != passwordTextField.text!.characters.count {
            errorMessages.append(Constants.NoretypePassword)
            highlightTextField(retypePassTextField)
        }
        
        //submit user or post error message
        if errorMessages.count > 0 {
            handleErrors()
        } else {
            //attempt to log in
            self.performSegueWithIdentifier("goBacktoProfile", sender: self)
//                        let user = PFUser()
//                        user.username = emailTextField.text
//                        user.email = emailTextField.text
//                        user.password = passwordTextField.text
//                        user["firstName"] = firstNameTextField.text
//                        user["lastName"] = lastNameTextField.text
//                        user.signUpInBackgroundWithBlock({
//                            (succeeded: Bool, error: NSError?) -> Void in
//                            if let error = error {
//                                let errorString = error.userInfo["error"] as? NSString
//                                self.errorMessages.append(errorString)
//                                handleErrors()
//                            } else {
//                                //save user information
//                                self.performSegueWithIdentifier("goBacktoProfile", sender: self)
//                            }
//                        })
        }
        
        //clear all so no left over for next sign up attempt
        errorMessages.removeAll()
    }
    
    func highlightTextField(textField: UITextField) {
        textField.layer.borderWidth = Constants.ErrorBorderWidth
        textField.layer.borderColor = UIColor.redColor().CGColor
    }

    func handleErrors() {
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: Constants.ErrorMessageWidth, height: Constants.ErrorMessageProportionHeight * CGFloat(errorMessages.count)))
        let errorSubView = UIView(frame: frame)
        errorSubView.center.x = signupButton.center.x
        errorSubView.center.y = signupButton.center.y + Constants.ErrorMessageProportionHeight * CGFloat(errorMessages.count)
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//    }


}
