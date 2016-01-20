//
//  OrderHistoryTableViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 12/31/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit
import Parse

class OrderHistoryTableViewController: UITableViewController {

    var orders = [PFObject]()
    var producePerOrder = [[PFObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return orders.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(producePerOrder[section].count)
        return producePerOrder[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("orderHistory", forIndexPath: indexPath) as! OrderHistoryTableViewCell
        //print(orders[indexPath.section].valueForKey("produce")![indexPath.row]["produceName"] as? String)
        let produce = producePerOrder[indexPath.section][indexPath.row]
        cell.produceLabel.text = produce.valueForKey(ParseKeys.ProduceNameKey) as? String
        cell.farmLabel.text = produce.valueForKey(ParseKeys.ProduceFarmKey) as? String
        let units = produce.valueForKey(ParseKeys.ProduceUnitsKey) as? Int
        cell.unitsLabel.text = "\(units!) units"
        let price = produce.valueForKey(ParseKeys.ProducePriceKey) as? Float
        cell.priceLabel.text = "$\(price!)"
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = orders[section].createdAt!
//        let components = NSCalendar.currentCalendar().components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: date)
//        let day = components.day
//        let dateformatter = NSDateFormatter()
//        let month = dateformatter.monthSymbols[components.month]
//        let year = components.year
//        return "Date: \(month) \(day), \(year)"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.stringFromDate(date)
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
