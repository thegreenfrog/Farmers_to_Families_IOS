//
//  SignUpViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 11/8/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePassTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func signupButton(sender: UIButton) {
        //make sure inputs are filled in properly
        if firstNameTextField.textColor == UIColor.lightGrayColor() {
            errorMessages.append(Constants.noFirstName)
            firstNameTextField.layer.borderWidth = Constants.errorBorderWidth
            firstNameTextField.layer.borderColor = UIColor.redColor().CGColor
        }
        if lastNameTextField.textColor == UIColor.lightGrayColor() {
            errorMessages.append(Constants.noLastName)
            lastNameTextField.layer.borderWidth = Constants.errorBorderWidth
            lastNameTextField.layer.borderColor = UIColor.redColor().CGColor
        }
        if emailTextField.textColor == UIColor.lightGrayColor() {
            errorMessages.append(Constants.noemail)
            emailTextField.layer.borderWidth = Constants.errorBorderWidth
            emailTextField.layer.borderColor = UIColor.redColor().CGColor
        }
        if passwordTextField.textColor == UIColor.lightGrayColor() || passwordTextField.text!.characters.count < 6 {
            errorMessages.append(Constants.noPassword)
            passwordTextField.layer.borderWidth = Constants.errorBorderWidth
            passwordTextField.layer.borderColor = UIColor.redColor().CGColor
        }
        if retypePassTextField.textColor == UIColor.lightGrayColor() || retypePassTextField.text!.characters.count != passwordTextField.text!.characters.count {
            errorMessages.append(Constants.noretypePassword)
            retypePassTextField.layer.borderWidth = Constants.errorBorderWidth
            retypePassTextField.layer.borderColor = UIColor.redColor().CGColor
        }
        
        //submit user or post error message
        if errorMessages.count > 0 {
            let errorOrigin = CGPoint(x: signupButton.layer.bounds.origin.x, y: signupButton.layer.bounds.origin.y + (Constants.errorMessageProportionHeight / 2) * CGFloat(errorMessages.count))
            let frame = CGRect(origin: errorOrigin, size: CGSize(width: Constants.errorMessageWidth, height: Constants.errorMessageProportionHeight * CGFloat(errorMessages.count)))
            let errorLabel = UILabel(frame: frame)
            let count = 0
            for error in errorMessages {
                if count == 0{
                    errorLabel.text = error
                }
                errorLabel.text! += error
            }
            //self.view.addSubview(errorLabel)
        }
        
        //clear all so no left over for next sign up attempt
        errorMessages.removeAll()
    }
    
    struct Constants {
        static let noFirstName = "Please enter your first name"
        static let noLastName = "Please enter your last name"
        static let noemail = "Please enter your email address"
        static let noPassword = "Please enter a password with at least 6 characters"
        static let noretypePassword = "Please re-enter the same password"
        
        static let errorBorderWidth:CGFloat = 1.0
        static let errorMessageProportionHeight:CGFloat = 20.0
        static let errorMessageWidth:CGFloat = 200.0
    }
    
    var errorMessages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.text = "First Name"
        lastNameTextField.text = "Last Name"
        emailTextField.text = "Email Address"
        passwordTextField.text = "Enter Password (at least 6 characters)"
        retypePassTextField.text = "re-Enter Password"
        firstNameTextField.textColor = UIColor.lightGrayColor()
        lastNameTextField.textColor = UIColor.lightGrayColor()
        emailTextField.textColor = UIColor.lightGrayColor()
        passwordTextField.textColor = UIColor.lightGrayColor()
        retypePassTextField.textColor = UIColor.lightGrayColor()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGrayColor()
        }
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
