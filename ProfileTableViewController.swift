//
//  ProfileTableViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 11/11/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    // MARK: - Variables and Constants
    
    @IBOutlet weak var editInformationCell: UITableViewCell!
    @IBOutlet weak var locationCell: UIView!
    @IBOutlet weak var ordersCell: UILabel!
    
    let tabLabels = ["Edit Information", "Change Location", "Orders"]
    
    @IBAction func signInLogOutAction(sender: UIBarButtonItem) {
        if sender.title == Constants.signIn {
            signIn()
            
        } else {
            let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(
                title: "Yes",
                style: UIAlertActionStyle.Default)
                { (action: UIAlertAction) -> Void in
                    PFUser.logOut()
                    self.checkSignInStatus()
                }
            )
            alert.addAction(UIAlertAction(
                title: "Cancel",
                style: .Cancel)
                { (action: UIAlertAction) -> Void in
                    
                }
            )
            
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var signInLogOutButton: UIBarButtonItem!
    struct Constants {
        static let signInUpHeight: CGFloat = 25
        static let signInUpWidth: CGFloat = 80
        static let signInTitle = "Sign In"
        static let signUpTitle = "Sign Up"
        static let cornerRadius: CGFloat = 2.5
        static let signInVerticalSpacingFromCenter:CGFloat = 20
        
        static let signUpSegueID = "signUpPage"
        static let signInSegueID = "signInModal"
        static let notSignedInTitle = "Your Profile"
        static let signIn = "Sign In"
        static let logOut = "Log Out"
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        checkSignInStatus()
    }
    
    func checkSignInStatus() {
        if PFUser.currentUser() != nil {
            if let first = PFUser.currentUser()!["firstName"] as? String, last = PFUser.currentUser()!["lastName"] as? String {
                self.title = first + " " + last
                editInformationCell.hidden = false
                locationCell.hidden = false
                ordersCell.hidden = false
            } else {
                self.title = "No Name"
            }
            signInLogOutButton.title = Constants.logOut
        } else {
            self.title = Constants.notSignedInTitle
            signInLogOutButton.title = Constants.signIn
            editInformationCell.hidden = true
            locationCell.hidden = true
            ordersCell.hidden = true
            signIn()
        }
    }
    
    func signIn() {
        performSegueWithIdentifier(Constants.signInSegueID, sender: self)
    }
    
    //unwind function from sign-in and sign-up page
    @IBAction func unwindToProfile(segue: UIStoryboardSegue) {
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if PFUser.currentUser() == nil {
            return 0
        }
        return tabLabels.count
    }
    

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
