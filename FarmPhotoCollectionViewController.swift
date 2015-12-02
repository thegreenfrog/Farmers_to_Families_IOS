//
//  FarmPhotoCollectionViewController.swift
//  LocalFarming
//
//  Created by Chris Lu on 11/30/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit

class FarmPhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    struct Constants {
        static let reuseIdentifier = "photoCell"
        static let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    }
    
    var userPhotos = [UIImage]()

    @IBAction func goBackToFarmSearch(sender: UIBarButtonItem) {
        performSegueWithIdentifier("goBackFarmSearchFromPicture", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(FarmPhotoCollectionViewCell(), forCellWithReuseIdentifier: Constants.reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        //put image somewhere
        userPhotos.append(image!)
        

        self.collectionView?.reloadData()
    }
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .Camera
            picker.delegate = self
            picker.allowsEditing = true
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func addPhotoFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let picker = UIImagePickerController()
            picker.sourceType = .PhotoLibrary
            picker.delegate = self
            presentViewController(picker, animated: true, completion: nil)
        }
    }

    @IBAction func addPhoto(sender: UIBarButtonItem) {
        //pull up alert
        let alert = UIAlertController(title: "Select Photo Source", message: "Where do you want to pull up the photo?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(
            title: "Camera",
            style: UIAlertActionStyle.Default)
            {(action: UIAlertAction) -> Void in
                self.takePhoto()
            }
        )
        alert.addAction(UIAlertAction(title: "Photo Library",
            style: UIAlertActionStyle.Default)
            {(action: UIAlertAction) -> Void in
                self.addPhotoFromLibrary()
            }
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return userPhotos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.reuseIdentifier, forIndexPath: indexPath) as! FarmPhotoCollectionViewCell
        cell.backgroundColor = UIColor.blackColor()
        //cell.photoView.contentMode = .ScaleAspectFill
        cell.photoView.image = userPhotos[indexPath.row]
            var extraHeight: CGFloat = 0
            if cell.photoView.image?.aspectRatio > 0 {
                if let width = cell.photoView.superview?.frame.size.width {
                    let height = width / cell.photoView.image!.aspectRatio
                    extraHeight = height - cell.photoView.frame.height
                    cell.photoView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                }
            } else {
                extraHeight = -cell.photoView.frame.height
                cell.photoView.frame = CGRectZero
            }
            preferredContentSize = CGSize(width: preferredContentSize.width, height: preferredContentSize.height + extraHeight)
        // Configure the cell
    
        return cell
    }
    
//    func collectionView(collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAtIndexPath indexPath: NSIndexPath) ->CGSize {
//            if (indexPath.row < userPhotos.count) {
//                let photo = userPhotos[indexPath.row]
//                var size = photo.size
//                size.width += 10
//                size.height += 10
//                return size
//            }
//            return CGSize(width: 10, height: 10)
//    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return Constants.sectionInsets
    }


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}
