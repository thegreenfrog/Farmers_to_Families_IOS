//
//  FarmTableViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 11/22/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit
import Parse

class FarmTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    var produce = [Produce]()
    var filteredProduceSearch = [Produce]()

    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredProduceSearch = produce
        
        self.tableView.registerClass(FarmCell.self, forCellReuseIdentifier: NSStringFromClass(FarmCell))
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 1.0)
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "FarmTableViewController", bundle: nibBundleOrNil)
        let getProduce = PFQuery(className: "AvailableProduce")
        getProduce.findObjectsInBackgroundWithBlock({ (objects, err) -> Void in
            if err != nil {
                return
            }
            if let produce = objects {
                for item in produce {
                    let name = item["produceName"] as? String
                    let farm = item["farm"] as? String
                    let quantity = item["units"] as! Int
                    let price = item["price"] as! Float
                    let id = item.objectId
                    let category = item["category"] as? String
                    let prod = Produce(i: id!, n: name!, f: farm!, p: price, q: quantity, c: category!)
                    self.produce.append(prod)
                }
                self.tableView.reloadData()
            }
        })
//        let getFarms = PFQuery(className: "FarmClass")
//        getFarms.findObjectsInBackgroundWithBlock({ (objects, err) -> Void in
//            if err != nil {
//                return
//            }
//            if let farmsObj = objects {
//                var count = farmsObj.count
//                for farm in farmsObj {
//                    let name = farm["farm"]
//                    let loc = farm["location"]
//                    var prodList = [PFObject]()
//                    let produce = farm.relationForKey("produce")
//                    let query = produce.query()
//                    query?.findObjectsInBackgroundWithBlock({ (objects, err) -> Void in
//                        if let allProd = objects {
//                            prodList = allProd
//                        }
//                        
//                        self.farms.append(LocalFarm(title: name as! String, locationName: loc as! String, produce: prodList))
//                        count--
//                        if count == 0 {
//                            self.tableView.reloadData()
//                        }
//                    })
//                }
//                
//            }
//            
//        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.active && searchController.searchBar.text != "" {
            return self.filteredProduceSearch.count
        } else {
            return self.produce.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(FarmCell), forIndexPath: indexPath) as? FarmCell
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: NSStringFromClass(FarmCell)) as? FarmCell
        }
        if searchController.active && searchController.searchBar.text != "" {
            cell?.nameLabel.text = self.filteredProduceSearch[indexPath.row].name
        } else {
            cell?.nameLabel.text = self.produce[indexPath.row].name
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var prod = produce[indexPath.row]
        if searchController.active && searchController.searchBar.text != "" {
            prod = filteredProduceSearch[indexPath.row]
        }
        let indProdVC = IndividualProduceViewController(p: prod)
        navigationController?.pushViewController(indProdVC, animated: true)
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
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        tableView.reloadData()
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        // Filter the array using the filter method
        self.filteredProduceSearch = self.produce.filter({(prod: Produce) -> Bool in
            let categoryMatch = (scope == "All") || (prod.category == scope)
            let nameMatch = prod.name.lowercaseString.rangeOfString(searchText)
            let farmMatch = prod.farm.lowercaseString.rangeOfString(searchText)
            return ((nameMatch != nil) || (farmMatch != nil)) && categoryMatch
        })
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }


}
