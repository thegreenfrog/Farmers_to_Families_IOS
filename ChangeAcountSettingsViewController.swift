//
//  ChangeAcountSettingsViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 11/13/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit
import Parse

class ChangeAcountSettingsViewController: UIViewController, UITextFieldDelegate {

    struct Constants {
        static let SaveSegue = "updatedAccount"
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    
     let placeholders = ["First Name","Last Name", "Email Address"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.text = String(PFUser.currentUser()!["firstName"])
        lastNameTextField.text = String(PFUser.currentUser()!["lastName"])
        emailTextField.text = PFUser.currentUser()!.email
        firstNameTextField.tag = 0
        lastNameTextField.tag = 1
        emailTextField.tag = 2
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        
    }

    @IBAction func cancelEdit(sender: UIBarButtonItem) {
        performSegueWithIdentifier(Constants.SaveSegue, sender: self)
    }
    @IBAction func saveChanges(sender: UIBarButtonItem) {
        if let user = PFUser.currentUser() {
            user.email = emailTextField.text
            user.username = emailTextField.text
            user["firstName"] = firstNameTextField.text
            user["lastName"] = lastNameTextField.text
            do {
                _ = try user.save()
            } catch {
                return
            }
        }
        performSegueWithIdentifier(Constants.SaveSegue, sender: self)
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

}
