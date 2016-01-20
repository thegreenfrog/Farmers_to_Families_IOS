//
//  IndividualProduceViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 1/15/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import UIKit
import Parse

class IndividualProduceViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var produceNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    var setPriceTextField: UITextField?
    var produceObject: PFObject?
    var quantity: Int?
    
    struct Constants {
        static let textFieldFiller = "New Price"
    }
    
    // MARK: - Update Bag Functions
    
    func createUpdateBagStatusScreen(text: String) -> UILabel{
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        let statusScreen = UILabel(frame: frame)
        statusScreen.text = text
        statusScreen.textAlignment = .Center
        statusScreen.backgroundColor = UIColor(red: 102/255, green: 139/255, blue: 139/255, alpha: 1.0)
        statusScreen.alpha = 0.0
        return statusScreen
    }
    
    //Never see transition to "Bag Updated" Screen
    func animateHideUpdateScreen(groceryVC: GroceryBagTableViewController, updatingBagScreen: UILabel) {
        let bagUpdatedStatusScreen = createUpdateBagStatusScreen("Bag Updated")
        self.view.addSubview(bagUpdatedStatusScreen)
        UIView.animateWithDuration(1.0,
            animations: {bagUpdatedStatusScreen.alpha = 1.0},
            completion: { finished in
                updatingBagScreen.removeFromSuperview()
                UIView.animateWithDuration(2.0, animations: {
                    updatingBagScreen.alpha = 0.0
                })
        })
        bagUpdatedStatusScreen.removeFromSuperview()
    }
    
    func createUnit() -> PFObject {
        let userProduceInstance = PFObject(className: "userQueuedProduce")
        userProduceInstance[ParseKeys.ProduceNameKey] = self.produceObject![ParseKeys.ProduceNameKey]
        if self.quantity == 0 {
            userProduceInstance[ParseKeys.ProducePriceKey] = NSNumberFormatter().numberFromString((self.setPriceTextField?.text)!)!.floatValue
            userProduceInstance[ParseKeys.ProduceBidKey] = true
            self.setPriceTextField?.text = Constants.textFieldFiller
            self.setPriceTextField?.textColor = UIColor.lightGrayColor()
        } else {
            userProduceInstance[ParseKeys.ProducePriceKey] = self.produceObject![ParseKeys.ProducePriceKey]
            userProduceInstance[ParseKeys.ProduceBidKey] = false
        }
        userProduceInstance[ParseKeys.ProduceSourceObjectID] = self.produceObject?.objectId
        userProduceInstance[ParseKeys.ProduceUnitsKey] = 1
        userProduceInstance[ParseKeys.ProduceFarmKey] = self.produceObject![ParseKeys.ProduceFarmKey]
        userProduceInstance[ParseKeys.ProducePurchasedStatusKey] = false
        userProduceInstance.saveInBackground()
        return userProduceInstance
    }
    
    func updateBag() {
        if quantity == 0 {
            let originalPrice = produceObject![ParseKeys.ProducePriceKey] as! Float
            if (NSNumberFormatter().numberFromString((setPriceTextField?.text)!) == nil) || NSNumberFormatter().numberFromString((setPriceTextField?.text)!)!.floatValue <= originalPrice {
                let alert = UIAlertController(title: "Price not correctly set", message: "Please enter a numeric price value that is greater than \(originalPrice)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(
                    title: "Ok",
                    style: UIAlertActionStyle.Default,
                    handler: nil
                    ))
                presentViewController(alert, animated: true, completion: nil)
                return
            }
        }
        //show "updating bag" screen
        let updatingBagScreen = createUpdateBagStatusScreen("Updating Bag")
        self.view.addSubview(updatingBagScreen)
        UIView.animateWithDuration(1.0,
            animations: {updatingBagScreen.alpha = 1.0},
            completion: {finished in
                //update bag
                //add info to grocerybagVC
                let navController = self.tabBarController?.viewControllers![2] as! UINavigationController
                let groceryVC = navController.topViewController as! GroceryBagTableViewController
                var iterator = 0
                for produce in groceryVC.produceList {
                    if produce.objectId == self.produceObject?.objectId {
                        groceryVC.produceList[iterator].incrementKey(ParseKeys.ProduceUnitsKey, byAmount: 1)
                        self.animateHideUpdateScreen(groceryVC, updatingBagScreen: updatingBagScreen)
                        return
                    }
                    iterator++
                }
                groceryVC.produceList.append(self.createUnit())
                groceryVC.tableView.reloadData()
                self.animateHideUpdateScreen(groceryVC, updatingBagScreen: updatingBagScreen)
                //animate in "bag updated" screen
        })
    }
    
    @IBAction func buyUnitAction(sender: UIButton) {
        updateBag()
    }
    
    // MARK: Lifecycle
    
    func setTextFieldSettings(textFieldFrame: CGRect) {
        setPriceTextField = UITextField(frame: textFieldFrame)
        setPriceTextField!.placeholder = Constants.textFieldFiller
        setPriceTextField!.textColor = UIColor.lightGrayColor()
        setPriceTextField!.font = UIFont.systemFontOfSize(15)
        setPriceTextField!.borderStyle = UITextBorderStyle.RoundedRect
        setPriceTextField!.textAlignment = .Center
        setPriceTextField!.autocorrectionType = UITextAutocorrectionType.No
        setPriceTextField!.keyboardType = UIKeyboardType.Default
        setPriceTextField!.returnKeyType = UIReturnKeyType.Done
        setPriceTextField!.clearButtonMode = UITextFieldViewMode.WhileEditing;
        setPriceTextField!.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        setPriceTextField!.delegate = self
        setPriceTextField!.center.x = self.view.center.x
    }
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
        super.viewDidLoad()
        
        produceNameLabel.text = produceObject![ParseKeys.ProduceNameKey] as? String
        let price = produceObject![ParseKeys.ProducePriceKey] as? Float
        priceLabel.text = "\(price!)"
        self.title = produceObject![ParseKeys.ProduceFarmKey] as? String
        quantityLabel.text = "\(quantity!)"
        
        if quantity == 0 {
            let labelFrame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width*2/3, height: 50)
            let inputPriceLabel = UILabel(frame: labelFrame)
            inputPriceLabel.numberOfLines = 0
            inputPriceLabel.textAlignment = .Center
            inputPriceLabel.center.x = self.view.center.x
            inputPriceLabel.text = "All units have been bought. Bid a higher price to buy"
            self.view.addSubview(inputPriceLabel)
            let textFieldFrame = CGRect(x: 0, y: self.view.bounds.height + 50, width: self.view.bounds.width/3, height: 40)
            setTextFieldSettings(textFieldFrame)
            self.view.addSubview(setPriceTextField!)
            //animate showing of both label and textfield
            UIView.animateWithDuration(1.0,
                delay: 0.0,
                options: .TransitionCurlUp,
                animations: {
                    inputPriceLabel.center.y -= self.view.frame.height/2
                    self.setPriceTextField!.center.y -= self.view.frame.height/2
                },
                completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TextField functions
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
        textField.textColor = UIColor.blackColor()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            textField.text = Constants.textFieldFiller
            textField.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateBag()
        print(textField.text)
        return true
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
