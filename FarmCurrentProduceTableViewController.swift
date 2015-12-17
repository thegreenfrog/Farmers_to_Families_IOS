//
//  FarmCurrentProduceTableViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 12/9/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit

class FarmCurrentProduceTableViewController: UITableViewController, ChangingPurchaseQueueDelegate {

    struct Constants {
        static let priceKey = "price"
        static let produceNameKey = "produceName"
        static let cellIdentifier = "produceCell"
        static let UpdateBagButtonHeight = CGFloat(50.0)
    }
    
    var produceList = [PFObject]()
    var producePurchaseCount = [String: Int]()
    var BagNeedsUpdating = false
    var UpdateBagButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for produce in produceList {
            producePurchaseCount[produce[Constants.produceNameKey] as! String] = 0
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func UpdateBagAction(sender: UIButton) {
        
    }
    
    func showUpdateBagButton() {
        print("showing update button")
        UpdateBagButton = UIButton()
        UpdateBagButton!.setTitle("Update Grocery Bag", forState: .Normal)
        UpdateBagButton!.frame = CGRectMake(0, self.view.bounds.maxY - self.tabBarController!.tabBar.frame.height, self.view.bounds.width, Constants.UpdateBagButtonHeight)
        UpdateBagButton!.addTarget(self, action: "UpdateBagAction:", forControlEvents: .TouchUpInside)
        UpdateBagButton?.backgroundColor = UIColor.blackColor()
        self.view.addSubview(UpdateBagButton!)
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.UpdateBagButton!.center.y -= Constants.UpdateBagButtonHeight
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func updatePurchaseCount(name: String, newValue: Int) {
        producePurchaseCount[name] = newValue
        print("updating count")
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
        cell?.ProduceName.text = produceList[indexPath.row][Constants.produceNameKey] as? String
        cell?.Price.text = produceList[indexPath.row][Constants.priceKey] as? String
        cell?.delegate = self
        // Configure the cell...
        
        return cell!
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

    }


}
