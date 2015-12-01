//
//  FarmTableViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 11/22/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit

class FarmTableViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate {

    var farms = [LocalFarm]()
    var filteredFarmSearch = [LocalFarm]()
    
    @IBAction func switchToMap(sender: UIBarButtonItem) {
        if sender.title == "MapView" {
            self.mapContainerView.hidden = false
            sender.title = "ListView"
        } else {
            self.mapContainerView.hidden = true
            sender.title = "MapView"
        }
    }
    
    @IBOutlet weak var switchLabel: UIBarButtonItem!
    @IBOutlet weak var mapContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapContainerView.hidden = true
        
        farms = [LocalFarm(title: "Rocky Ridge Farm", locationName: "Bowdoin", coordinate: CLLocationCoordinate2D(latitude: 44.028944, longitude: -69.946586), url: NSURL(string: "http://rockyridgeorchard.com/")), LocalFarm(title: "Milkweed Farms", locationName: "Brunswick", coordinate: CLLocationCoordinate2D(latitude: 43.883284, longitude: -69.997941), url: NSURL(string: "https://milkweedfarm.wordpress.com/")), LocalFarm(title: "Mitchell and Savage Maple Products", locationName: "Bowdoin", coordinate: CLLocationCoordinate2D(latitude: 43.905914, longitude: -69.963668), url: NSURL(string: "http://www.mainemaplekitchen.net/")), LocalFarm(title: "Tall Pines Farm", locationName: "Bowdoin", coordinate: CLLocationCoordinate2D(latitude: 44.027677, longitude: -70.023428), url: nil), LocalFarm(title: "Whatley Farm", locationName: "Topsham", coordinate: CLLocationCoordinate2D(latitude: 43.927544, longitude: -69.975946), url: nil)]
        filteredFarmSearch = farms
        self.tableView.reloadData()

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
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredFarmSearch.count
        } else {
            return self.farms.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        var thisFarm: LocalFarm
        if tableView == self.searchDisplayController!.searchResultsTableView {
            thisFarm = self.filteredFarmSearch[indexPath.row]
        } else {
            thisFarm = self.farms[indexPath.row]
        }
        cell.textLabel!.text = thisFarm.title
        cell.detailTextLabel?.text = thisFarm.locationName
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
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

    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredFarmSearch = self.farms.filter({(farm: LocalFarm) -> Bool in
            let titleMatch = farm.title?.rangeOfString(searchText)
            let locationMatch = farm.locationName.rangeOfString(searchText)
            return (titleMatch != nil) || (locationMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    @IBAction func unwindToFarmSearch(segue: UIStoryboardSegue) {
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            if identifier == "showMap" {
                if let destination = segue.destinationViewController as? FarmMapViewController {
                    destination.farms = self.filteredFarmSearch
                }
            } else if identifier == "showFarmDetail" {
                if let navCont = segue.destinationViewController as? UINavigationController {
                    if let destination = navCont.topViewController as? FarmDetailTableViewController {
                        if let row = self.tableView.indexPathForSelectedRow?.row {
                            let farm = filteredFarmSearch[row]
                            destination.farmDetails = farm
                            destination.navigationController?.title = farm.title
                        }
                    }
                }
            }
        }
    }


}
