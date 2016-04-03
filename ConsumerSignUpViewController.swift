//
//  ConsumerSignUpViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 3/31/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import UIKit
import Parse

class ConsumerSignUpViewController: UIViewController, UITextFieldDelegate {
    
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
    
    let placeholders = ["First Name", "Last Name", "Username (email)", "Password"]
    
    var firstNameText: UITextField!
    var lastNameText: UITextField!
    var emailText: UITextField!
    var passText: UITextField!
    
    var signUpButton: UIButton!
    
    var errorMessages = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width-10, height: 100)))
        firstNameText.borderStyle = .Line
        firstNameText.tag = 0
        firstNameText.font = UIFont.systemFontOfSize(30)
        firstNameText.returnKeyType = UIReturnKeyType.Done
        firstNameText.text = placeholders[firstNameText.tag]
        firstNameText.textColor = UIColor.lightGrayColor()
        firstNameText.delegate = self
        firstNameText.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(firstNameText)
        let firstNameCenterXConstraint = NSLayoutConstraint(item: firstNameText, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let firstNameLeftConstraint = NSLayoutConstraint(item: firstNameText, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 10)
        let firstNameCenterYContraint = NSLayoutConstraint(item: firstNameText, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: -100)
        self.view.addConstraint(firstNameCenterXConstraint)
        self.view.addConstraint(firstNameCenterYContraint)
        self.view.addConstraint(firstNameLeftConstraint)
        
        lastNameText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width-10, height: 100)))
        lastNameText.borderStyle = .Line
        lastNameText.tag = 1
        lastNameText.font = UIFont.systemFontOfSize(30)
        lastNameText.returnKeyType = UIReturnKeyType.Done
        lastNameText.text = placeholders[lastNameText.tag]
        lastNameText.textColor = UIColor.lightGrayColor()
        lastNameText.delegate = self
        lastNameText.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lastNameText)
        let lastNameCenterXConstraint = NSLayoutConstraint(item: lastNameText, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let lastNameLeftConstraint = NSLayoutConstraint(item: lastNameText, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 10)
        let lastNameCenterYContraint = NSLayoutConstraint(item: lastNameText, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: -50)
        self.view.addConstraint(lastNameCenterXConstraint)
        self.view.addConstraint(lastNameCenterYContraint)
        self.view.addConstraint(lastNameLeftConstraint)
        
        emailText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width-10, height: 100)))
        emailText.borderStyle = .Line
        emailText.tag = 2
        emailText.font = UIFont.systemFontOfSize(30)
        emailText.returnKeyType = UIReturnKeyType.Done
        emailText.text = placeholders[emailText.tag]
        emailText.textColor = UIColor.lightGrayColor()
        emailText.delegate = self
        emailText.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emailText)
        let emailCenterXConstraint = NSLayoutConstraint(item: emailText, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let emailLeftConstraint = NSLayoutConstraint(item: emailText, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 10)
        let emailCenterYContraint = NSLayoutConstraint(item: emailText, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
        self.view.addConstraint(emailCenterXConstraint)
        self.view.addConstraint(emailCenterYContraint)
        self.view.addConstraint(emailLeftConstraint)
        
        passText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width-10, height: 100)))
        passText.borderStyle = .Line
        passText.tag = 3
        passText.font = UIFont.systemFontOfSize(30)
        passText.returnKeyType = UIReturnKeyType.Done
        passText.text = placeholders[passText.tag]
        passText.textColor = UIColor.lightGrayColor()
        passText.delegate = self
        passText.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(passText)
        let passCenterXConstraint = NSLayoutConstraint(item: passText, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let passLeftConstraint = NSLayoutConstraint(item: passText, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 10)
        let passCenterYContraint = NSLayoutConstraint(item: passText, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 50)
        self.view.addConstraint(passCenterXConstraint)
        self.view.addConstraint(passCenterYContraint)
        self.view.addConstraint(passLeftConstraint)
        
        signUpButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width-10, height: 75)))
        signUpButton.setTitle("Sign In", forState: .Normal)
        signUpButton.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signUpButton)
        let signUpCenterXConstraint = NSLayoutConstraint(item: signUpButton, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let signUpLeftConstraint = NSLayoutConstraint(item: signUpButton, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 10)
        let signUpCenterYContraint = NSLayoutConstraint(item: signUpButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 100)
        self.view.addConstraint(signUpCenterXConstraint)
        self.view.addConstraint(signUpCenterYContraint)
        self.view.addConstraint(signUpLeftConstraint)
        signUpButton.addTarget(self, action: "signUpAction", forControlEvents: .TouchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func highlightTextField(textField: UITextField) {
        textField.layer.borderWidth = Constants.ErrorBorderWidth
        textField.layer.borderColor = UIColor.redColor().CGColor
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

    func signUpAction() {
        //make sure inputs are filled in properly
        if firstNameText.textColor == UIColor.lightGrayColor() {
            errorMessages.append(Constants.NoFirstName)
            highlightTextField(firstNameText)
        }
        if lastNameText.textColor == UIColor.lightGrayColor() {
            errorMessages.append(Constants.NoLastName)
            highlightTextField(lastNameText)
        }
        if emailText.textColor == UIColor.lightGrayColor() || emailText.text?.rangeOfString(Constants.EmailRegex, options: .RegularExpressionSearch) == nil {
            errorMessages.append(Constants.Noemail)
            highlightTextField(emailText)
        }
        if passText.textColor == UIColor.lightGrayColor() || passText.text!.characters.count < 6 {
            errorMessages.append(Constants.NoPassword)
            highlightTextField(passText)
        }
        if passText.textColor == UIColor.lightGrayColor() || passText.text!.characters.count != passText.text!.characters.count {
            errorMessages.append(Constants.NoretypePassword)
            highlightTextField(passText)
        }
        
        //submit user or post error message
        if errorMessages.count > 0 {
            handleErrors()
        } else {
            //attempt to log in
            let user = PFUser()
            user.username = emailText.text
            user.email = emailText.text
            user.password = passText.text
            user["firstName"] = firstNameText.text
            user["lastName"] = lastNameText.text
            user.signUpInBackgroundWithBlock({
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    if let errorString = error.userInfo["error"] as? NSString {
                        self.errorMessages.append(errorString as String)
                    }
                    self.handleErrors()
                } else {
                    //set up application
                    let tabBarVC = UITabBarController()
                    let VC = [FarmTableViewController(), ProfileTableViewController(), GroceryBagTableViewController()]
                    tabBarVC.viewControllers = VC
                    self.presentViewController(tabBarVC, animated: true, completion: nil)
                }
            })
        }
        
    }
    
    func exitPage() {
        self.dismissViewControllerAnimated(true, completion: nil)
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
