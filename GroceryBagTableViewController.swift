//
//  GroceryBagTableViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 12/16/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit
import Parse

class GroceryBagTableViewController: UITableViewController {

    struct Constants {
        static let produceNameKey = "produceName"
        static let produceFarmKey = "farm"
        static let produceNumKey = "produceCount"
        static let producePurchasedStatusKey = "purchased"
        static let CheckoutButtonHeight = CGFloat(50)
    }
    
    var CheckoutButton: UIButton?
    
    var produceList = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print(produceList.count)
        
        if(produceList.count > 0 && CheckoutButton == nil) {
            CheckoutButton = UIButton()
            CheckoutButton?.setTitle("Checkout", forState: .Normal)
            CheckoutButton?.frame = CGRectMake(0, self.view.bounds.maxY - (self.tabBarController?.tabBar.bounds.height)!, self.view.bounds.width, Constants.CheckoutButtonHeight)
            CheckoutButton?.addTarget(self, action: "CheckoutAction:", forControlEvents: .TouchUpInside)
            CheckoutButton?.center.y -= 50
            CheckoutButton?.backgroundColor = UIColor.blackColor()
            self.view.addSubview(CheckoutButton!)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            produceList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            if produceList.count == 0 {
                animateButtonDisappear()
            }
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if self.tableView.editing {
            return UITableViewCellEditingStyle.Delete
        }
        return UITableViewCellEditingStyle.None
    }
    
    func animateButtonDisappear() {
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.CheckoutButton?.center.y += 50
            }, completion: {(value: Bool) in
                self.CheckoutButton?.removeFromSuperview()
                self.CheckoutButton = nil
        })
    }
    
    func ExecuteCheckout() {
        let orderObject = PFObject.init(className: "userOrder")
        orderObject.setObject(PFUser.currentUser()!.username!, forKey: "user")
        let orderRelation = orderObject.relationForKey("purchased")
        var totalProduce = self.produceList.count
        for produce in self.produceList {
            produce[Constants.producePurchasedStatusKey] = true
            let purchasedProduce = PFObject.init(className: "producePurchased")
            purchasedProduce.setValue(produce.valueForKey(Constants.produceNameKey), forKey: Constants.produceNameKey)
            purchasedProduce.setValue(produce.valueForKey(Constants.produceFarmKey), forKey: Constants.produceFarmKey)
            purchasedProduce.setValue(produce.valueForKey(Constants.produceNumKey), forKey: Constants.produceNumKey)
            purchasedProduce.setValue(PFUser.currentUser()!.username!, forKey: "user")
            purchasedProduce.saveInBackgroundWithBlock{ (success, error) in
                if success {
                    orderRelation.addObject(purchasedProduce)
                }
                totalProduce--
                if totalProduce == 0 {
                    orderObject.saveInBackground()
                }
            }
        }
        produceList = []
        self.tableView.reloadData()
    }
    
    func CheckoutAction(sender: UIButton) {
        let alert = UIAlertController(title: "Checking Out", message: "Are you sure you want to check out?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(
            title: "Yes",
            style: UIAlertActionStyle.Default)
            { (action: UIAlertAction) -> Void in
                self.ExecuteCheckout()
                self.animateButtonDisappear()
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return produceList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroceryCell", forIndexPath: indexPath) as! GroceryBagTableViewCell
        let produce = produceList[indexPath.row]
        cell.produceNameLabel.text = produce[Constants.produceNameKey] as? String
        let produceNum = produce[Constants.produceNumKey] as? Int
        cell.produceCountLabel.text = "\(produceNum!)"
        cell.farmNameLabel.text = produce[Constants.produceFarmKey] as? String
        
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
