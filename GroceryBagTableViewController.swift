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
    
    var produceList = [PFObject]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(produceList.count > 0 && CheckoutButton == nil) {
            CheckoutButton = UIButton()
            CheckoutButton?.setTitle("Checkout", forState: .Normal)
            CheckoutButton?.frame = CGRectMake(0, self.view.bounds.maxY - (self.tabBarController?.tabBar.bounds.height)!, self.view.bounds.width, Constants.CheckoutButtonHeight)
            CheckoutButton?.addTarget(self, action: "CheckoutAction:", forControlEvents: .TouchUpInside)
            CheckoutButton?.center.y -= 50
            CheckoutButton?.backgroundColor = UIColor.blackColor()
            self.view.addSubview(CheckoutButton!)
            
            let rightConstraint = NSLayoutConstraint(item: CheckoutButton!, attribute: NSLayoutAttribute.TrailingMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1, constant: 0)
            self.view.addConstraint(rightConstraint)
            let leftConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.LeadingMargin, relatedBy: NSLayoutRelation.Equal, toItem: CheckoutButton, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1, constant: 0)
            self.view.addConstraint(leftConstraint)
            let bottomConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.BottomMargin, relatedBy: NSLayoutRelation.Equal, toItem: CheckoutButton, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1, constant: 0)
            self.view.addConstraint(bottomConstraint)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func savePurchaseHistory(produce: PFObject, inout orderObject: PFObject, orderID: NSString, inout orderRelation: PFRelation, inout totalProduce: Int) -> PFObject {
        let purchasedProduce = PFObject.init(className: ParseKeys.UserOrderProduceClassName)
        purchasedProduce.setValue(produce.valueForKey(ParseKeys.ProduceNameKey), forKey: ParseKeys.ProduceNameKey)
        purchasedProduce.setValue(produce.valueForKey(ParseKeys.ProduceSourceObjectID), forKey: ParseKeys.ProduceSourceObjectID)
        purchasedProduce.setValue(produce.valueForKey(ParseKeys.ProducePriceKey), forKey: ParseKeys.ProducePriceKey)
        purchasedProduce.setValue(orderID, forKey: ParseKeys.UserOrderId)
        purchasedProduce.setValue(produce.valueForKey(ParseKeys.ProduceFarmKey), forKey: ParseKeys.ProduceFarmKey)
        purchasedProduce.setValue(produce.valueForKey(ParseKeys.ProduceUnitsKey), forKey: ParseKeys.ProduceUnitsKey)
        purchasedProduce.setValue(PFUser.currentUser()!.username!, forKey: ParseKeys.UserOrderUser)
        return purchasedProduce
    }
    
    func ExecuteCheckout() {
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
                        orderObject.saveInBackground()
                    }
                }
                continue
            }
            
            //retrieve updated produce information
            let produceQuantity = produce[ParseKeys.ProduceUnitsKey] as! Int
            let objectQuery = PFQuery(className: ParseKeys.CurrentProduceClassName)
            objectQuery.whereKey(ParseKeys.PFObjectObjectID, equalTo: produce.valueForKey(ParseKeys.ProduceSourceObjectID)! as! String)
            objectQuery.getFirstObjectInBackgroundWithBlock{ (object, error) in
                //check to make sure object still exists, enough inventory to make purchase
                if error != nil || object == nil || (object?.valueForKey(ParseKeys.ProduceUnitsKey) as! Int) < produceQuantity{
                    //notify user purchase could not be done
                    self.showCheckoutError(produce[ParseKeys.ProduceNameKey] as! String)
                    return
                }
                object!.incrementKey(ParseKeys.ProduceUnitsKey, byAmount: -produceQuantity)
                object!.saveInBackground()
                //create purchase history
                let purchasedProduce = self.savePurchaseHistory(produce, orderObject: &orderObject, orderID: orderID, orderRelation: &orderRelation, totalProduce: &totalProduce)
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
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier, forIndexPath: indexPath) as! GroceryBagTableViewCell
        let produce = produceList[indexPath.row]
        cell.produceNameLabel.text = produce[ParseKeys.ProduceNameKey] as? String
        let produceNum = produce[ParseKeys.ProduceUnitsKey] as? Int
        print(produceNum)
        cell.produceCountLabel.text = "\(produceNum!)"
        let price = produce[ParseKeys.ProducePriceKey] as? Float
        cell.priceLabel.text = "$\(price!)"
        cell.farmNameLabel.text = produce[ParseKeys.ProduceFarmKey] as? String
        
        return cell
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
