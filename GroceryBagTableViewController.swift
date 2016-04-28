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
        static let cellIdentifier = "GroceryCell"
        static let CheckoutButtonHeight = CGFloat(50)
    }
    
    var CheckoutButton: UIButton?
    var noProduceLabel: UILabel?
    
    var produceList = [PFObject]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
        self.tableView.backgroundColor = UIColor(red: 205/255, green: 205/255, blue: 193/255, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
        self.tableView.registerClass(GroceryBagTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(GroceryBagTableViewCell))
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let getBag = PFQuery(className: "groceryProduce")
        getBag.whereKey("username", equalTo: NSUserDefaults.standardUserDefaults().valueForKey("username")!)
        getBag.findObjectsInBackgroundWithBlock({ (objects, err) -> Void in
            if err != nil {
                print(err)
                return
            }
            if let produce = objects {
                print(produce.count)
                self.produceList = produce
            }
            
            if(self.produceList.count > 0 && self.CheckoutButton == nil) {
                //show checkout button
                self.CheckoutButton = UIButton()
                self.CheckoutButton?.setTitle("Checkout", forState: .Normal)
                self.CheckoutButton?.frame = CGRectMake(0, self.view.bounds.maxY - (self.tabBarController?.tabBar.bounds.height)!, self.view.bounds.width, Constants.CheckoutButtonHeight)
                self.CheckoutButton?.addTarget(self, action: "CheckoutAction:", forControlEvents: .TouchUpInside)
                self.CheckoutButton?.center.y -= 50
                self.CheckoutButton?.backgroundColor = UIColor.blackColor()
                self.view.addSubview(self.CheckoutButton!)
                let centerXConstraint = NSLayoutConstraint(item: self.CheckoutButton!, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
                self.view.addConstraint(centerXConstraint)
            }
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "GroceryBagTableViewController", bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Checkout functions
    
    func animateButtonDisappear() {
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.CheckoutButton?.center.y += 50
            }, completion: {(value: Bool) in
                self.CheckoutButton?.removeFromSuperview()
                self.CheckoutButton = nil
        })
    }
    
    func showCheckoutError(produce: String) {
        let alert = UIAlertController(title: "Checkout Error", message: "\(produce) could not be bought. It will not be part of your bag", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: UIAlertActionStyle.Default)
            { (action: UIAlertAction) -> Void in
                self.ExecuteCheckout()
                self.animateButtonDisappear()
            }
        )
        
        presentViewController(alert, animated: true, completion: nil)

    }
    
    //note: should ultimately be done on Cloud code when scaling so user doesn't
    //have to cache a huge amount of order info. Also security/privacy is a related issue
    func replaceOtherBid(produceID: String) -> Bool {
        var hasError = false
        //If so, find specific produce order to replace
        let query = PFQuery(className: ParseKeys.UserOrderProduceClassName)
        query.whereKey(ParseKeys.ProduceSourceObjectID, equalTo: produceID)
        query.orderByAscending(ParseKeys.ProducePriceKey)
        query.addDescendingOrder(ParseKeys.createdAtKey)
        query.getFirstObjectInBackgroundWithBlock{ (object, error) in
            if error != nil || object == nil {
                hasError = true
                return
            }
            let units = object?.valueForKey(ParseKeys.ProduceUnitsKey) as! Int
            if units > 1 {
                object?.incrementKey(ParseKeys.ProduceUnitsKey, byAmount: -1)
                object?.saveInBackground()
                return
            }
            let orderId = object![ParseKeys.UserOrderId] as! String
            //get order
            let orderQuery = PFQuery(className: ParseKeys.UserOrderClassName)
            orderQuery.whereKey(ParseKeys.UserOrderId, equalTo: orderId)
            orderQuery.getFirstObjectInBackgroundWithBlock{ (orderObject, error) in
                if error != nil || orderObject == nil {
                    hasError = true
                    return
                }
                let relation = orderObject?.relationForKey(ParseKeys.UserOrderRelationKey)
                relation?.removeObject(object!)
                
                //notify oubtid user
                let user = orderObject?.valueForKey(ParseKeys.UserOrderUser)
                let notification = PFObject(className: ParseKeys.NotificationClassName)
                notification.setValue(user, forKey: ParseKeys.NotificationUser)
                notification.setValue(orderObject?.valueForKey(ParseKeys.UserOrderId), forKey: ParseKeys.NotificationOrderId)
                notification.setValue(object?.valueForKey(ParseKeys.ProduceSourceObjectID), forKey: ParseKeys.NotificationProduceId)
                notification.setValue(object?.valueForKey(ParseKeys.ProduceNameKey), forKey: ParseKeys.NotificationProduceName)
                notification.saveInBackground()
                
                print("removed \(object![ParseKeys.ProduceNameKey] as! String) from order #\(orderObject![ParseKeys.UserOrderId] as! String)")
                object!.deleteInBackground()
                //notify order's user of removal
                
            }
        }
        return !hasError
        //replace it and notify user account.
        
    }
    
    //as seen here: http://stackoverflow.com/questions/26845307/generate-random-alphanumeric-string-in-swift
    func randomStringWithLength (len: Int) -> NSString {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    //helper function to create "userOrder" class instance for this order
    func savePurchaseHistory(produce: PFObject, inout orderObject: PFObject, orderID: NSString, inout orderRelation: PFRelation, inout totalProduce: Int) -> PFObject {
        let purchasedProduce = PFObject.init(className: ParseKeys.UserOrderProduceClassName)
        purchasedProduce.setValue(produce["produce"] as? String, forKey: ParseKeys.ProduceNameKey)
        purchasedProduce.setValue(produce["produceId"] as? String, forKey: ParseKeys.ProduceSourceObjectID)
        purchasedProduce.setValue(produce["price"] as? Float, forKey: ParseKeys.ProducePriceKey)
        purchasedProduce.setValue(orderID, forKey: ParseKeys.UserOrderId)
        purchasedProduce.setValue(produce["farm"] as? String, forKey: ParseKeys.ProduceFarmKey)
        purchasedProduce.setValue(produce["quantity"] as? Int, forKey: ParseKeys.ProduceUnitsKey)
        purchasedProduce.setValue(NSUserDefaults.standardUserDefaults().valueForKey("username"), forKey: ParseKeys.UserOrderUser)
        return purchasedProduce
    }
    
    //function called to handle user checkout
    func ExecuteCheckout() {
        //create class instance
        var orderObject = PFObject.init(className: ParseKeys.UserOrderClassName)
        let orderID = randomStringWithLength(7)
        orderObject.setObject(orderID, forKey: ParseKeys.UserOrderId)
        orderObject.setObject(PFUser.currentUser()!.username!, forKey: ParseKeys.UserOrderUser)
        var orderRelation = orderObject.relationForKey(ParseKeys.UserOrderRelationKey)
        var totalProduce = self.produceList.count
        for produce in self.produceList {
            //check if outbid product. 
            let didBid = produce[ParseKeys.ProduceBidKey] as! Bool
            if didBid {
                replaceOtherBid(produce[ParseKeys.ProduceSourceObjectID] as! String)
                let purchasedProduce = savePurchaseHistory(produce, orderObject: &orderObject, orderID: orderID, orderRelation: &orderRelation, totalProduce: &totalProduce)
                purchasedProduce.saveInBackgroundWithBlock{ (success, error) in
                    if success {
                        orderRelation.addObject(purchasedProduce)
                    }
                    totalProduce--
                    if totalProduce == 0 {
                        orderObject.saveInBackground()//always make sure you save this after you finish with pfRelation
                    }
                }
                continue
            }
            
            //retrieve updated produce information
            let produceQuantity = produce["quantity"] as! Int
            let objectQuery = PFQuery(className: "AvailableProduce")
            objectQuery.whereKey(ParseKeys.PFObjectObjectID, equalTo: produce["produceId"] as! String)
            objectQuery.getFirstObjectInBackgroundWithBlock{ (object, error) in
                //check to make sure object still exists, enough inventory to make purchase
                if error != nil || object == nil || (object?.valueForKey(ParseKeys.ProduceUnitsKey) as! Int) < produceQuantity{
                    //notify user purchase could not be done
                    self.showCheckoutError(produce["produce"] as! String)
                    return
                }
                object!.incrementKey(ParseKeys.ProduceUnitsKey, byAmount: -produceQuantity)
                object!.saveInBackground()
                //create purchase history
                let purchasedProduce = self.savePurchaseHistory(produce, orderObject: &orderObject, orderID: orderID, orderRelation: &orderRelation, totalProduce: &totalProduce)
                purchasedProduce.saveInBackgroundWithBlock{ (success, error) -> Void in
                    if success {
                        orderRelation.addObject(purchasedProduce)
                    }
                    totalProduce--
                    if totalProduce == 0 {
                        orderObject.saveInBackground()
                    }
                }
            }
            
        }
        //remove all elements from groceryBag class now that order has been processed
        for prod in produceList {
            prod.deleteInBackground()
        }
        produceList = []
        self.tableView.reloadData()
//        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
//        if settings?.types == UIUserNotificationType.None {
//            let alertSetting = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
//            UIApplication.sharedApplication().registerUserNotificationSettings(alertSetting)
//        }
        
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
        if self.produceList.count == 0 {//tell user that there is no produce in bag
            let frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
            noProduceLabel = UILabel(frame: frame)
            noProduceLabel!.text = "No Produce in Bag"
            noProduceLabel!.textAlignment = .Center
            noProduceLabel!.textColor = UIColor.darkGrayColor()
            noProduceLabel!.sizeToFit()
            self.tableView.backgroundView = noProduceLabel
            self.tableView.separatorStyle = .None
            return 0
        }
        // #warning Incomplete implementation, return the number of sections
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .SingleLine
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return produceList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(GroceryBagTableViewCell), forIndexPath: indexPath) as? GroceryBagTableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: NSStringFromClass(GroceryBagTableViewCell)) as? GroceryBagTableViewCell
        }
        let produce = produceList[indexPath.row]
        let name = produce["produce"] as? String
        cell!.produceNameLabel.text = name
        let produceNum = produce["quantity"] as? Int
        cell!.produceCountLabel.text = "\(produceNum!)"
        let price = produce["price"] as? Float
        cell!.priceLabel.text = "$\(price!)"
        cell!.farmNameLabel.text = produce["farm"] as? String
        cell!.backgroundColor = UIColor(red: 245/255, green: 222/255, blue: 179/255, alpha: 1.0)
        
        return cell!
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
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
