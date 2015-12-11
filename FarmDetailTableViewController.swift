//
//  FarmDetailTableViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 11/29/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit

class FarmDetailTableViewController: UITableViewController {
    
    var farmDetails: LocalFarm?
    
    let detailTabs = ["See what is available", "Whats coming up in season", "See more about what they are about", "Pictures!"]
    
    let segueNames = ["showCurrentProduce", "showFutureProduce", "showWebsite", "showPictures"]
    
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return detailTabs.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FarmDetailCell", forIndexPath: indexPath)
        cell.textLabel?.text = detailTabs[indexPath.row]
        if indexPath.row == 2 && farmDetails?.websiteURL == nil {
            cell.textLabel?.textColor = UIColor.lightGrayColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        // Configure the cell...

        return cell
    }
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.textColor != UIColor.lightGrayColor() {
            if indexPath.row == 3 {

                
            }
            performSegueWithIdentifier(segueNames[indexPath.row], sender: self)
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
    
    
    @IBAction func goBackToSearch(sender: UIBarButtonItem) {
        performSegueWithIdentifier("returnToSearch", sender: sender)
    }
    
    @IBAction func unwindBackToFarmDetail(segue: UIStoryboardSegue) {
        
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showWebsite" {
            let destination = segue.destinationViewController as? WebsiteViewController
            destination?.webURL = farmDetails?.websiteURL
        } else if segue.identifier == "showPictures" {
            let destination = segue.destinationViewController as? UINavigationController
            if let photoCollectionVC = destination?.topViewController as? FarmPhotoCollectionViewController {
                photoCollectionVC.farmName = farmDetails
                let query = PFQuery(className: "FarmPhotos")
                query.whereKey("farm", equalTo: (farmDetails?.title)!)
                query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                    if error != nil ||  objects == nil{
                        return
                    }
                    for object in objects! {
                        if let image = object["image"] as? PFFile {
                            image.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                                if (error == nil) {
                                    photoCollectionVC.userPhotos.append(UIImage(data: imageData!)!)
                                    photoCollectionVC.collectionView?.reloadData()
                                }
                            })
                        }
                    }
                    
                })
            }
            
        } else if segue.identifier == "showCurrentProduce" {
            let destination = segue.destinationViewController as? UINavigationController
            if let produceVC = destination?.topViewController as? FarmCurrentProduceTableViewController {
                destination?.title = farmDetails?.title
                let query = PFQuery(className: "AvailableProduce")
                query.whereKey("Farm", equalTo: (farmDetails?.title)!)
                query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil {
                        if let objects = objects {
                            produceVC.produceList = objects
                            produceVC.tableView.reloadData()
                        }
                    }
                })
            }
        }
    }


}
