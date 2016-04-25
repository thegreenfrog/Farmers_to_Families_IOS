//
//  FarmerSignUpViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 4/18/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import UIKit

class FarmerSignUpViewController: UIViewController, UITextFieldDelegate {
    
    struct Constants {
        static let NoFirstName = "Please enter your first name"
        static let NoLastName = "Please enter your last name"
        static let Noemail = "Please enter your email address"
        static let NoPassword = "Please enter a password with at least 6 characters"
        static let NoretypePassword = "Please re-enter the same password"
        
        static let EmailRegex = "[^@]+[@][a-z0-9]+[.][a-z]*"
        
    }
    
    let placeholders = ["First Name", "Last Name", "Username (email)", "Farm Name", "Password", "Retype Password"]
    
    var modalListener: ModalFarmerTransitionListener?
    
    var exitButton: UIButton!
    var firstNameText: UITextField!
    var lastNameText: UITextField!
    var emailText: UITextField!
    var farmName: UITextField!
    var passText: UITextField!
    var retypePassText: UITextField!
    
    var signUpButton: UIButton!
    
    var errorMessages = [String]()
    
    func drawScreen() {
        exitButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 75)))
        exitButton.setTitle("X", forState: .Normal)
        exitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        exitButton.titleLabel!.font = UIFont.systemFontOfSize(24)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: "exitPage", forControlEvents: .TouchUpInside)
        
        firstNameText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 100)))
        firstNameText.borderStyle = .Line
        firstNameText.backgroundColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 0.8)
        firstNameText.tag = 0
        firstNameText.font = UIFont.systemFontOfSize(24)
        firstNameText.returnKeyType = UIReturnKeyType.Done
        firstNameText.text = placeholders[firstNameText.tag]
        firstNameText.textColor = UIColor.lightGrayColor()
        firstNameText.delegate = self
        firstNameText.translatesAutoresizingMaskIntoConstraints = false
        
        lastNameText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 100)))
        lastNameText.borderStyle = .Line
        lastNameText.backgroundColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 0.8)
        lastNameText.tag = 1
        lastNameText.font = UIFont.systemFontOfSize(24)
        lastNameText.returnKeyType = UIReturnKeyType.Done
        lastNameText.text = placeholders[lastNameText.tag]
        lastNameText.textColor = UIColor.lightGrayColor()
        lastNameText.delegate = self
        lastNameText.translatesAutoresizingMaskIntoConstraints = false
        
        emailText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 100)))
        emailText.borderStyle = .Line
        emailText.backgroundColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 0.8)
        emailText.tag = 2
        emailText.font = UIFont.systemFontOfSize(24)
        emailText.returnKeyType = UIReturnKeyType.Done
        emailText.text = placeholders[emailText.tag]
        emailText.textColor = UIColor.lightGrayColor()
        emailText.delegate = self
        emailText.translatesAutoresizingMaskIntoConstraints = false
        
        farmName = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 100)))
        farmName.borderStyle = .Line
        farmName.backgroundColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 0.8)
        farmName.tag = 3
        farmName.font = UIFont.systemFontOfSize(24)
        farmName.returnKeyType = UIReturnKeyType.Done
        farmName.text = placeholders[passText.tag]
        farmName.textColor = UIColor.lightGrayColor()
        farmName.delegate = self
        farmName.translatesAutoresizingMaskIntoConstraints = false
        
        passText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 100)))
        passText.borderStyle = .Line
        passText.backgroundColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 0.8)
        passText.tag = 4
        passText.font = UIFont.systemFontOfSize(24)
        passText.returnKeyType = UIReturnKeyType.Done
        passText.text = placeholders[passText.tag]
        passText.textColor = UIColor.lightGrayColor()
        passText.delegate = self
        passText.translatesAutoresizingMaskIntoConstraints = false
        
        retypePassText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 100)))
        retypePassText.borderStyle = .Line
        retypePassText.backgroundColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 0.8)
        retypePassText.tag = 5
        retypePassText.font = UIFont.systemFontOfSize(24)
        retypePassText.returnKeyType = UIReturnKeyType.Done
        retypePassText.text = placeholders[retypePassText.tag]
        retypePassText.textColor = UIColor.lightGrayColor()
        retypePassText.delegate = self
        retypePassText.translatesAutoresizingMaskIntoConstraints = false
        
        signUpButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 75)))
        signUpButton.setTitle("Sign Up", forState: .Normal)
        signUpButton.backgroundColor = UIColor.clearColor()
        signUpButton.titleLabel?.font = UIFont.systemFontOfSize(24)
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: "signUpAction", forControlEvents: .TouchUpInside)
        
        let screenStackView = UIStackView()
        screenStackView.addArrangedSubview(firstNameText)
        screenStackView.addArrangedSubview(lastNameText)
        screenStackView.addArrangedSubview(passText)
        screenStackView.addArrangedSubview(retypePassText)
        
        let fillerView = UIView()
        fillerView.translatesAutoresizingMaskIntoConstraints = false
        fillerView.heightAnchor.constraintEqualToConstant(20).active = true
        screenStackView.addArrangedSubview(fillerView)
        screenStackView.addArrangedSubview(signUpButton)
        screenStackView.alignment = .Fill
        screenStackView.axis = .Vertical
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
        // Dispose of any resources that can be recreated.
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
    
    func checkForErrors() {
        if firstNameText.textColor == UIColor.lightGrayColor() {
            errorMessages.append(Constants.NoFirstName)
            return
        }
        if lastNameText.textColor == UIColor.lightGrayColor() {
            errorMessages.append(Constants.NoLastName)
            return
        }
        if emailText.textColor == UIColor.lightGrayColor() || emailText.text?.rangeOfString(Constants.EmailRegex, options: .RegularExpressionSearch) == nil {
            errorMessages.append(Constants.Noemail)
            return
        }
        if passText.textColor == UIColor.lightGrayColor() || passText.text!.characters.count < 6 {
            errorMessages.append(Constants.NoPassword)
            return
        }
        if passText.textColor == UIColor.lightGrayColor() || retypePassText.text!.characters.count != passText.text!.characters.count {
            errorMessages.append(Constants.NoretypePassword)
            return
        }
    }
    
    func signUpAction() {
        //make sure inputs are filled in properly
        checkForErrors()
        
        //submit user or post error message
        if errorMessages.count > 0 {
            handleErrors()
        } else {
            //attempt to log in
            
        }
        
    }
    
    func exitPage() {
        modalListener?.returnFromModal(false)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - TextField Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.textColor == UIColor.lightGrayColor() {
            textField.text = nil
            textField.textColor = UIColor.whiteColor()
            if textField.tag == 3 || textField.tag == 4 {
                textField.secureTextEntry = true
            }
        }
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text!.isEmpty {
            if textField.tag == 3 || textField.tag == 4 {
                textField.secureTextEntry = false
            }
            textField.textColor = UIColor.lightGrayColor()
            textField.text = placeholders[textField.tag]
        }
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
