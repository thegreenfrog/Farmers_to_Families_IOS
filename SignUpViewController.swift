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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.text = "First Name"
        lastNameTextField.text = "Last Name"
        emailTextField.text = "Email Address"
        passwordTextField.text = "Enter Password"
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
