//
//  FarmCurrentProduceTableViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 12/9/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit
import Parse

class FarmCurrentProduceTableViewController: UITableViewController, ChangingPurchaseQueueDelegate {

    struct Constants {

        static let cellIdentifier = "produceCell"
        static let UpdateBagButtonHeight = CGFloat(50.0)
    }
    //should not allow for multiple produce names. Fucks up key/value pair a
    var produceList = [(PFObject, Int)]()
    var BagNeedsUpdating = false
    var UpdateBagButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func UpdateBagAction(sender: UIButton) {
        let navController = self.tabBarController?.viewControllers![2] as! UINavigationController
        let groceryVC = navController.topViewController as! GroceryBagTableViewController
        var iterator = 0
        for (produce, num) in produceList {
            if num > 0 {
                let userProduceInstance = PFObject(className: "userQueuedProduce")
                userProduceInstance.objectId = produce.objectId
                userProduceInstance[ParseKeys.ProduceNameKey] = produce[ParseKeys.ProduceNameKey]
                userProduceInstance[ParseKeys.ProduceNumKey] = num
                userProduceInstance[ParseKeys.ProduceFarmKey] = produce[ParseKeys.ProduceFarmKey]
                userProduceInstance[ParseKeys.ProducePurchasedStatusKey] = false
                groceryVC.produceList.append(userProduceInstance)
                produceList[iterator].1 = 0
            }
            iterator++
        }
        self.tableView.reloadData()
        groceryVC.tableView.reloadData()
        BagNeedsUpdating = false
        UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.UpdateBagButton?.center = CGPoint(x: CGFloat(self.view.bounds.maxX - 50), y: CGFloat(self.view.bounds.maxY - 50))
            self.UpdateBagButton?.frame = CGRectMake(self.view.bounds.maxX - 50, self.view.bounds.maxY - 50, 10, 1)
            self.view.layoutIfNeeded()
            }, completion: { (value: Bool) in
                self.UpdateBagButton?.removeFromSuperview()
                self.UpdateBagButton = nil
        })
        
    }
    
    func showUpdateBagButton() {
        UpdateBagButton = UIButton()
        UpdateBagButton!.setTitle("Update Grocery Bag", forState: .Normal)
        UpdateBagButton!.frame = CGRectMake(0, self.view.bounds.maxY - self.tabBarController!.tabBar.frame.height, self.view.bounds.width, Constants.UpdateBagButtonHeight)
        UpdateBagButton!.addTarget(self, action: "UpdateBagAction:", forControlEvents: .TouchUpInside)
        UpdateBagButton?.backgroundColor = UIColor.blackColor()
        self.view.addSubview(UpdateBagButton!)
        let rightConstraint = NSLayoutConstraint(item: UpdateBagButton!, attribute: NSLayoutAttribute.TrailingMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1, constant: 0)
        self.view.addConstraint(rightConstraint)
        let leftConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.LeadingMargin, relatedBy: NSLayoutRelation.Equal, toItem: UpdateBagButton, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1, constant: 0)
        self.view.addConstraint(leftConstraint)
        let bottomConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.BottomMargin, relatedBy: NSLayoutRelation.Equal, toItem: UpdateBagButton, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1, constant: 0)
        self.view.addConstraint(bottomConstraint)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.UpdateBagButton!.center.y -= Constants.UpdateBagButtonHeight
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func updatePurchaseCount(index: Int, newValue: Int) {
        produceList[index].1 = newValue
        if !BagNeedsUpdating {
            BagNeedsUpdating = true
            showUpdateBagButton()
        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier, forIndexPath: indexPath) as? ProduceTableViewCell
        cell?.ProduceName.text = produceList[indexPath.row].0[ParseKeys.ProduceNameKey] as? String
        let price = produceList[indexPath.row].0[ParseKeys.ProducePriceKey] as! Float
        cell?.Price.text = "$\(price)"
        cell?.rowNum = indexPath.row
        cell?.delegate = self
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showIndividualProduce", sender: indexPath.row)
    }

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destVC = segue.destinationViewController as? IndividualProduceViewController {
            let row = sender as! Int
            let (produce, num) = produceList[row]
                destVC.produceObject = produce
                destVC.quantity = num
            
        }
    }


}
