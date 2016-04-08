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

    var produceImageView: UIImageView!
    var farmNameLabel: UILabel!
    var priceLabel: UILabel!
    var purchaseButton: UIButton!
    var setPriceTextField: UITextField?
    var produce: Produce!
    
    struct Constants {
        static let textFieldFiller = "New Price"
    }
    
    // MARK: - Update Bag Functions
    
    func createUpdateBagStatusScreen(text: String) -> UILabel{
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        let statusScreen = UILabel(frame: frame)
        statusScreen.text = text
        statusScreen.textAlignment = .Center
        statusScreen.backgroundColor = Colors.lightBrown//UIColor(red: 102/255, green: 139/255, blue: 139/255, alpha: 1.0)
        statusScreen.alpha = 0.0
        return statusScreen
    }
    
    //Never see transition to "Bag Updated" Screen
    func animateHideUpdateScreen(groceryVC: GroceryBagTableViewController, updatingBagScreen: UILabel) {
        updatingBagScreen.text = "Bag Updated"
        UIView.animateWithDuration(1.0, delay: 1.5, options: UIViewAnimationOptions.TransitionNone, animations: { updatingBagScreen.alpha = 0.0 }, completion: { (finished: Bool) -> Void in
            updatingBagScreen.removeFromSuperview()
        })
    }
    
    func createUnit() -> PFObject {
        let userProduceInstance = PFObject(className: "userQueuedProduce")
        userProduceInstance[ParseKeys.ProduceNameKey] = produce.name
        if produce.quantity == 0 {
            let price = self.setPriceTextField?.text
            userProduceInstance[ParseKeys.ProducePriceKey] = NSNumberFormatter().numberFromString(price!)!.doubleValue
            userProduceInstance[ParseKeys.ProduceBidKey] = true
            self.setPriceTextField?.text = Constants.textFieldFiller
            self.setPriceTextField?.textColor = UIColor.lightGrayColor()
        } else {
            userProduceInstance[ParseKeys.ProducePriceKey] = produce.price
            userProduceInstance[ParseKeys.ProduceBidKey] = false
        }
        userProduceInstance[ParseKeys.ProduceSourceObjectID] = self.produce.id
        userProduceInstance[ParseKeys.ProduceUnitsKey] = 1
        userProduceInstance[ParseKeys.ProduceFarmKey] = produce.farm
        userProduceInstance[ParseKeys.ProducePurchasedStatusKey] = false
        userProduceInstance.saveInBackground()
        return userProduceInstance
    }
    
    func updateBag() {
        if produce.quantity == 0 {
            let originalPrice = produce.price
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
                for (index, prod) in groceryVC.produceList.enumerate() {
                    let produceId = prod.valueForKey(ParseKeys.ProduceSourceObjectID) as? String
                    if  produceId == self.produce.id {
                        groceryVC.produceList[index].incrementKey(ParseKeys.ProduceUnitsKey, byAmount: 1)
                        groceryVC.produceList[index].saveInBackground()
                        print(groceryVC.produceList[index].valueForKey(ParseKeys.ProduceUnitsKey))
                        self.animateHideUpdateScreen(groceryVC, updatingBagScreen: updatingBagScreen)
                        groceryVC.tableView.reloadData()
                        return
                    }
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
    
    func showQuantityStatus() {
//        if produce.quantity == 0 {
//            quantityLabel.textColor = UIColor.redColor()
//            quantityLabel.text = "Out of Stock"
//        } else if produce.quantity > 3 {
//            quantityLabel.textColor = UIColor.redColor()
//            quantityLabel.text = "Low Stock"
//        }
    }
    
    func drawproduceImageView() {
        produceImageView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 200, height: 200)))
        produceImageView.image = UIImage(named: "produce_placeholder.jpg")
        produceImageView.layer.borderColor = Colors.woodColor.CGColor
        produceImageView.layer.borderWidth = 2.0
        produceImageView.layer.shadowColor = UIColor.blackColor().CGColor
        produceImageView.layer.shadowOffset = CGSizeMake(0, 1)
        produceImageView.layer.shadowOpacity = 1
        produceImageView.layer.shadowRadius = 2.0
        produceImageView.clipsToBounds = false
    }
    
    func drawLabels() {
        farmNameLabel = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 75)))
        farmNameLabel.text = produce.farm
        
        
        priceLabel = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 60)))
        priceLabel.text = "\(produce.price)"
        
        self.view.addSubview(priceLabel)
        
        purchaseButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 60)))
        purchaseButton.setTitle("Buy a Unit", forState: .Normal)
        self.view.addSubview(purchaseButton)

        drawproduceImageView()
        let stack1 = UIStackView(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: self.view.frame.height)))
        stack1.addArrangedSubview(farmNameLabel)
        stack1.addArrangedSubview(produceImageView)
        stack1.addArrangedSubview(priceLabel)
        stack1.addArrangedSubview(purchaseButton)
        stack1.axis = .Vertical
        stack1.alignment = .Center
        stack1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stack1)
        let centerXConstraint = NSLayoutConstraint(item: stack1, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: stack1, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
        self.view.addConstraint(centerXConstraint)
        self.view.addConstraint(centerYConstraint)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        drawLabels()
        
        self.title = produce.name
        self.navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
        self.view.backgroundColor = UIColor(red: 205/255, green: 205/255, blue: 193/255, alpha: 1.0)
        
        showQuantityStatus()
        
        if produce.price == 0 {
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
                    inputPriceLabel.center.y -= self.view.frame.height*5/12
                    self.setPriceTextField!.center.y -= self.view.frame.height*5/12
                },
                completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init(p: Produce) {
        super.init(nibName: nil, bundle: nil)
        produce = p
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
