//
//  FarmDetailTableViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 11/29/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit
import Parse

class FarmDetailTableViewController: UITableViewController {
    
    struct Constants {
        static let cellIdentifier = "FarmDetailCell"
    }
    
    var farmDetails: LocalFarm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
        self.tableView.backgroundColor = UIColor(red: 205/255, green: 205/255, blue: 193/255, alpha: 1.0)
        self.tableView.registerClass(FarmDetailTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(FarmDetailTableViewCell))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if farmDetails != nil {
            return (farmDetails?.produceList.count)!
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(FarmDetailTableViewCell), forIndexPath: indexPath) as? FarmDetailTableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: NSStringFromClass(FarmDetailTableViewCell)) as? FarmDetailTableViewCell
        }
        cell!.textLabel?.text = farmDetails?.produceList[indexPath.row]["produceName"] as? String
        cell!.backgroundColor = UIColor(red: 245/255, green: 222/255, blue: 179/255, alpha: 1.0)
        // Configure the cell...

        return cell!
    }
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.textColor != UIColor.lightGrayColor() {
            
        }
        
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



}
