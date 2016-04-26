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
    var setPriceTextField: UITextField!
    var produce: Produce!
    
    var screenStackView: UIStackView!
    var scrollView: UIScrollView!
    
    struct Constants {
        static let textFieldFiller = "New Price"
    }
    
    
    // MARK: Lifecycle
    
    func rendersetPriceTextFieldSettings() {
        setPriceTextField = UITextField()
        setPriceTextField?.alpha = 0.0
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
        setPriceTextField.heightAnchor.constraintEqualToConstant(40).active = true
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
        farmNameLabel = UILabel()
        farmNameLabel.text = produce.farm
        
        priceLabel = UILabel()
        priceLabel.text = "\(produce.price)"
        priceLabel.numberOfLines = 0
        priceLabel.textAlignment = .Center
        
        
        rendersetPriceTextFieldSettings()
        
        purchaseButton = UIButton()
        purchaseButton.setTitle("Buy a Unit", forState: .Normal)
        purchaseButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        purchaseButton.addTarget(self, action: "buyUnitAction", forControlEvents: .TouchUpInside)
        
        drawproduceImageView()
        
        screenStackView = UIStackView()
        screenStackView.addArrangedSubview(farmNameLabel)
        screenStackView.addArrangedSubview(produceImageView)
        screenStackView.addArrangedSubview(priceLabel)
        screenStackView.addArrangedSubview(setPriceTextField)
        screenStackView.addArrangedSubview(purchaseButton)
        screenStackView.axis = .Vertical
        screenStackView.alignment = .Center
        screenStackView.distribution = .EqualSpacing
        screenStackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView = UIScrollView()
        scrollView.frame = self.view.bounds
        
        let contentView = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: self.view.frame.height)))
        contentView.addSubview(screenStackView)
        screenStackView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor).active = true
        screenStackView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        screenStackView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor).active = true
        screenStackView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
        
        scrollView.addSubview(contentView)
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
//        scrollView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
//        scrollView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
//        scrollView.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
//        scrollView.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
//        
//        screenStackView.leadingAnchor.constraintEqualToAnchor(scrollView.leadingAnchor).active = true
//        screenStackView.trailingAnchor.constraintEqualToAnchor(scrollView.trailingAnchor).active = true
//        screenStackView.topAnchor.constraintEqualToAnchor(scrollView.topAnchor).active = true
//        screenStackView.bottomAnchor.constraintEqualToAnchor(scrollView.bottomAnchor).active = true
        //scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)

        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        drawLabels()
        
        self.title = produce.name
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor.whiteColor()

    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        let top = topLayoutGuide.length
        let bottom = bottomLayoutGuide.length
        

//        self.scrollView.frame =  self.view.bounds
//        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        
        ///self.screenStackView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        //print(screenStackView.frame)
        print(scrollView.contentSize)
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let outBidLabel = UILabel()
        outBidLabel.text = "All units have been bought. Bid a higher price to buy"
        outBidLabel.textAlignment = .Center
        outBidLabel.numberOfLines = 0
        
        if produce.quantity == 0 {
            //swap
            UIView.transitionWithView(self.priceLabel, duration: 1.0, options: .TransitionFlipFromLeft, animations: {
                self.priceLabel.text = "All units have been bought. Bid a higher price to buy."
                
                }, completion: nil)
            UIView.transitionWithView(self.setPriceTextField, duration: 1.0, options: .TransitionFlipFromLeft, animations: {
                self.setPriceTextField.alpha = 1.0
                }, completion: nil)
            
            
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
                //see if the user has already added one unit of this produce to its bag
                let findThisProduceInBag = PFQuery(className: "groceryProduce")
                findThisProduceInBag.whereKey("produceId", equalTo: self.produce.id)
                findThisProduceInBag.getFirstObjectInBackgroundWithBlock({ (object, err) -> Void in
                    if let found = object {//if found, then just increment quantity
                        found.incrementKey("quantity")
                        found.saveInBackground()
                        updatingBagScreen.text = "Bag Updated"
                        UIView.animateWithDuration(1.0, delay: 1.5, options: UIViewAnimationOptions.TransitionNone, animations: { updatingBagScreen.alpha = 0.0 }, completion: { (finished: Bool) -> Void in
                            updatingBagScreen.removeFromSuperview()
                        })
                        return
                    } else {
                        /*
                        Adds the current produce to the grocery bag by adding another instance of the class "groceryProduce"
                        */
                        let produceObject = PFObject(className: "groceryProduce")
                        produceObject.setValue(self.produce.name, forKey: "produce")
                        produceObject.setValue(self.produce.farm, forKey: "farm")
                        produceObject.setValue(self.produce.price, forKey: "price")
                        produceObject.setValue(NSUserDefaults.standardUserDefaults().valueForKey("username"), forKey: "username")
                        produceObject.setValue(1, forKey: "quantity")
                        produceObject.setValue(self.produce.id, forKey: "produceId")
                        produceObject.saveInBackground()
                        //show "Bag Updated" and then hide dissolve the view
                        updatingBagScreen.text = "Bag Updated"
                        UIView.animateWithDuration(1.0, delay: 1.5, options: UIViewAnimationOptions.TransitionNone, animations: { updatingBagScreen.alpha = 0.0 }, completion: { (finished: Bool) -> Void in
                            updatingBagScreen.removeFromSuperview()
                        })
                    }
                })

                
                //update bag
                //add info to grocerybagVC
//                let navController = self.tabBarController?.viewControllers![2] as! UINavigationController
//                let groceryVC = navController.topViewController as! GroceryBagTableViewController
//                for (index, prod) in groceryVC.produceList.enumerate() {
//                    let produceId = prod.valueForKey(ParseKeys.ProduceSourceObjectID) as? String
//                    if  produceId == self.produce.id {
//                        groceryVC.produceList[index].incrementKey(ParseKeys.ProduceUnitsKey, byAmount: 1)
//                        groceryVC.produceList[index].saveInBackground()
//                        print(groceryVC.produceList[index].valueForKey(ParseKeys.ProduceUnitsKey))
//                        self.animateHideUpdateScreen(groceryVC, updatingBagScreen: updatingBagScreen)
//                        groceryVC.tableView.reloadData()
//                        return
//                    }
//                }
//                groceryVC.produceList.append(self.createUnit())
//                groceryVC.tableView.reloadData()
//                self.animateHideUpdateScreen(groceryVC, updatingBagScreen: updatingBagScreen)
                //animate in "bag updated" screen
        })
        
        
    }
    
    func buyUnitAction() {
        updateBag()
    }
    

    // MARK: - TextField functions
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.textColor == UIColor.lightGrayColor() {
            textField.text = ""
            textField.textColor = UIColor.blackColor()
        }
        
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
