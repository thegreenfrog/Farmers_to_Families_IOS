//
//  FarmCurrentProduceTableViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 12/9/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit
import Parse

class FarmCurrentProduceTableViewController: UITableViewController {

    struct Constants {

        static let cellIdentifier = "produceCell"
        static let UpdateBagButtonHeight = CGFloat(50.0)
    }
    //should not allow for multiple produce names. Fucks up key/value pair
    var produceList = [PFObject]()
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
        cell?.ProduceName.text = produceList[indexPath.row][ParseKeys.ProduceNameKey] as? String
        let price = produceList[indexPath.row][ParseKeys.ProducePriceKey] as! Float
        cell?.Price.text = "$\(price)"
        cell?.rowNum = indexPath.row
        
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
            let produce = produceList[row]
            destVC.produceObject = produce
            let quantity = produce[ParseKeys.ProduceUnitsKey] as? Int
            print(quantity)
            destVC.quantity = quantity
            
        }
    }


}
