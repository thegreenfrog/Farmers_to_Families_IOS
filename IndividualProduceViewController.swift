//
//  IndividualProduceViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 1/15/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import UIKit
import Parse

class IndividualProduceViewController: UIViewController {

    @IBOutlet weak var produceNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    var produceObject: PFObject?
    var quantity: Int?
    
    func animateHideUpdateScreen(groceryVC: GroceryBagTableViewController, updatingBagScreen: UILabel) {
        groceryVC.tableView.reloadData()
        UIView.animateWithDuration(1.0,
            animations: {updatingBagScreen.text = "Bag Updated"},
            completion: { finished in
                UIView.animateWithDuration(0.5, animations: {
                    updatingBagScreen.alpha = 0.0
                })
        })
        updatingBagScreen.removeFromSuperview()
    }
    
    @IBAction func buyUnitAction(sender: UIButton) {
        //show "updating bag" screen
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        let updatingBagScreen = UILabel(frame: frame)
        updatingBagScreen.text = "Updating Bag"
        updatingBagScreen.textAlignment = .Center
        updatingBagScreen.backgroundColor = UIColor(red: 102/255, green: 139/255, blue: 139/255, alpha: 1.0)
        updatingBagScreen.alpha = 0.0
        self.view.addSubview(updatingBagScreen)
        UIView.animateWithDuration(0.5,
            animations: {updatingBagScreen.alpha = 1.0},
            completion: {finished in
                //update bag
                //add info to grocerybagVC
                let navController = self.tabBarController?.viewControllers![2] as! UINavigationController
                let groceryVC = navController.topViewController as! GroceryBagTableViewController
                var iterator = 0
                for produce in groceryVC.produceList {
                    if produce.objectId == self.produceObject?.objectId {
                        groceryVC.produceList[iterator].incrementKey(ParseKeys.ProduceNumKey, byAmount: 1)
                        self.animateHideUpdateScreen(groceryVC, updatingBagScreen: updatingBagScreen)
                        return
                    }
                    iterator++
                }
                let userProduceInstance = PFObject(className: "userQueuedProduce")
                userProduceInstance.objectId = self.produceObject!.objectId
                userProduceInstance[ParseKeys.ProduceNameKey] = self.produceObject![ParseKeys.ProduceNameKey]
                userProduceInstance[ParseKeys.ProduceNumKey] = 1
                userProduceInstance[ParseKeys.ProduceFarmKey] = self.produceObject![ParseKeys.ProduceFarmKey]
                userProduceInstance[ParseKeys.ProducePurchasedStatusKey] = false
                groceryVC.produceList.append(userProduceInstance)
                self.animateHideUpdateScreen(groceryVC, updatingBagScreen: updatingBagScreen)
                //animate in "bag updated" screen

        })
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        produceNameLabel.text = produceObject![ParseKeys.ProduceNameKey] as? String
        let price = produceObject![ParseKeys.ProducePriceKey] as? Float
        priceLabel.text = "\(price!)"
        self.title = produceObject![ParseKeys.ProduceFarmKey] as? String
        quantityLabel.text = "\(quantity!)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
