//
//  ProfileTableViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 11/11/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit
import Parse

class ProfileTableViewController: UITableViewController {

    // MARK: - Variables and Constants
    
    struct Constants {
        static let signInUpHeight: CGFloat = 25
        static let signInUpWidth: CGFloat = 80
        static let signInTitle = "Sign In"
        static let signUpTitle = "Sign Up"
        static let cornerRadius: CGFloat = 2.5
        static let signInVerticalSpacingFromCenter:CGFloat = 20
        
        static let cellIdentifier = "profileCell"
        static let signUpSegueID = "signUpPage"
        static let signInSegueID = "signInModal"
        static let notSignedInTitle = "Your Profile"
        static let signIn = "Sign In"
        static let logOut = "Log Out"
    }
    
    let TabLabels = [["Starred", "Order History", "Notifications"],["Edit Information"]]
    let segueIdentifiers = [["seeStarred", "seeOrders", "seeNotifications"], ["changeUserInfo"]]//"changeLocation", "seeOrders"

    @IBOutlet weak var signInLogOutButton: UIBarButtonItem!

    
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
                    self.tableView.reloadData()
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
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.backgroundColor = Colors.lightGray
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
        self.tableView.registerClass(ProduceTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ProduceTableViewCell))
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        //signInLogOutButton.tintColor = UIColor.blackColor()

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "ProfileTableViewController", bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func checkSignInStatus() {
//        if PFUser.currentUser() != nil {
//            if let first = PFUser.currentUser()!["firstName"] as? String, last = PFUser.currentUser()!["lastName"] as? String {
//                self.title = first + " " + last
//            } else {
//                self.title = "No Name"
//            }
//            signInLogOutButton.title = Constants.logOut
//        } else {
//            self.title = Constants.notSignedInTitle
//            signInLogOutButton.title = Constants.signIn
//            signIn()
//        }
//    }
    
    func signIn() {
        performSegueWithIdentifier(Constants.signInSegueID, sender: self)
    }
    
    //unwind function from sign-in and sign-up page
    @IBAction func unwindToProfile(segue: UIStoryboardSegue) {
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        if PFUser.currentUser() == nil {
//            self.title = Constants.notSignedInTitle
//            signInLogOutButton.title = Constants.signIn
//            signIn()
//            return 0
//        } else {
//            if let first = PFUser.currentUser()!["firstName"] as? String, last = PFUser.currentUser()!["lastName"] as? String {
//                self.title = first + " " + last
//            } else {
//                self.title = "No Name"
//            }
//            signInLogOutButton.title = Constants.logOut
//            return TabLabels[section].count
//        }
        return 0
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = TabLabels[indexPath.section][indexPath.row]
        cell.accessoryType = .DisclosureIndicator
        cell.backgroundColor = Colors.lightBrown
        //cell.layer.borderColor = UIColor(red: 160/255, green: 82/255, blue: 45/255, alpha: 1.0).CGColor
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(segueIdentifiers[indexPath.section][indexPath.row], sender: self)
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }

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

    
    // MARK: - Navigation
    
    func getProduceInOrder(object: PFObject, ordersVC: OrderHistoryTableViewController) {
        print(object.objectId)
        let relation = object.relationForKey("purchased")
        let query = relation.query()
        
        query!.findObjectsInBackgroundWithBlock( { (results, error) in
            if error == nil {
                print(results?.count)
                if let produceList = results {
                    ordersVC.producePerOrder.append(produceList)
                    ordersVC.orders.append(object)
                    ordersVC.tableView.reloadData()
                }
            }
            
        })
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "seeOrders" {
            let ordersVC = segue.destinationViewController as! OrderHistoryTableViewController
            let query = PFQuery(className: ParseKeys.UserOrderClassName)
            let currentUser = PFUser.currentUser()!.username!
            query.whereKey("user", equalTo: currentUser)
            //print(currentUser)
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            self.getProduceInOrder(object, ordersVC: ordersVC)
                        }
                        
                    }
                }
            })
        } else if segue.identifier == "seeNotifications" {
            let notificationVC = segue.destinationViewController as! NotificationsTableViewController
            let query = PFQuery(className: ParseKeys.NotificationClassName)
            let currentUser = PFUser.currentUser()!.username!
            query.whereKey(ParseKeys.NotificationUser, equalTo: currentUser)
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                if error != nil {
                    return
                }
                if let objects = objects {
                    for object in objects {
                        notificationVC.notificationList.append(object)
                    }
                    notificationVC.tableView.reloadData()
                }
            })
        }
    }
}
