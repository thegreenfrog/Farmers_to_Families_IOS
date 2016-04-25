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
    }
    
    var modalListener: ModalConsumerTransitionListener?
    
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    
    var signInButton: UIButton!
    var exitButton: UIButton!
    
    let placeholders = ["Username (email)", "Password"]
    var errorMessages = [String]()
    
    
    // MARK: - Life Cycle
    
    func drawScreen() {
        exitButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: 75, height: 75)))
        exitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        exitButton.titleLabel!.font = UIFont.systemFontOfSize(24)
        exitButton.setTitle("X", forState: .Normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: "exitPage", forControlEvents: .TouchUpInside)
        
        emailTextField = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width-10, height: 100)))
        emailTextField.borderStyle = .Line
        emailTextField.backgroundColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 0.8)
        emailTextField.tag = 0
        emailTextField.font = UIFont.systemFontOfSize(24)
        emailTextField.returnKeyType = UIReturnKeyType.Done
        emailTextField.text = placeholders[emailTextField.tag]
        emailTextField.textColor = UIColor.lightGrayColor()
        emailTextField.delegate = self
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordTextField = UITextField(frame: CGRectMake(0, 0, self.view.frame.width-10, 75))
        passwordTextField.borderStyle = .Line
        passwordTextField.backgroundColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 0.8)
        passwordTextField.tag = 1
        passwordTextField.font = UIFont.systemFontOfSize(24)
        passwordTextField.returnKeyType = UIReturnKeyType.Done
        passwordTextField.text = placeholders[passwordTextField.tag]
        passwordTextField.textColor = UIColor.lightGrayColor()
        passwordTextField.delegate = self
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        signInButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 75)))
        signInButton.setTitle("Sign In", forState: .Normal)
        signInButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signInButton.titleLabel?.font = UIFont.systemFontOfSize(24)
        signInButton.backgroundColor = UIColor.clearColor()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self, action: "signInAction", forControlEvents: .TouchUpInside)
        
        let screenStackView = UIStackView(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: self.view.frame.height)))
        screenStackView.addArrangedSubview(emailTextField)
        screenStackView.addArrangedSubview(passwordTextField)
        let fillerView = UIView()
        fillerView.translatesAutoresizingMaskIntoConstraints = false
        fillerView.heightAnchor.constraintEqualToConstant(20).active = true
        screenStackView.addArrangedSubview(fillerView)
        screenStackView.addArrangedSubview(signInButton)
        screenStackView.axis = .Vertical
        screenStackView.alignment = .Fill
        screenStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(screenStackView)
        
        screenStackView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, constant: -25).active = true
        screenStackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        screenStackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: -75).active = true
        
        self.view.addSubview(exitButton)
        exitButton.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 50).active = true
        exitButton.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor, constant: -12).active = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawScreen()
        self.view.backgroundColor = UIColor.clearColor()
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
            textField.textColor = UIColor.whiteColor()
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
        modalListener?.returnFromModal(false)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func checkForErrors() {
        if emailTextField.textColor == UIColor.lightGrayColor() {
            errorMessages.append(Constants.NoEmail)
            return
        }
        if passwordTextField.textColor == UIColor.lightGrayColor() {
            errorMessages.append(Constants.NoPassword)
            return
        }
    }
    
    func signInAction() {
        self.modalListener?.returnFromModal(true)
        self.dismissViewControllerAnimated(true, completion: {
            self.modalListener?.goToApp()
        })
        return
        
        checkForErrors()//check for improper inputs
        
        if(errorMessages.count > 0) {//show error messages if improper inputs exist
            handleErrors()
        } else {//attempt to log in
            
            PFUser.logInWithUsernameInBackground(emailTextField.text!, password: passwordTextField.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    //save user info
                    let keyChainWrapper = KeychainWrapper()
                    keyChainWrapper.mySetObject(self.passwordTextField.text, forKey: kSecValueData)
                    keyChainWrapper.writeToKeychain()
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
                    NSUserDefaults.standardUserDefaults().setValue(self.emailTextField.text, forKey: "username")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    self.modalListener?.returnFromModal(true)
                    self.dismissViewControllerAnimated(true, completion: {
                        self.modalListener?.goToApp()
                    })
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
        var allErrors = ""
        var first = true
        for error in errorMessages {
            if(!first) {
                allErrors += "\n"
            }
            allErrors += error
            first = false
        }
        let alert = UIAlertController(title: nil, message: allErrors, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
        errorMessages = []
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
