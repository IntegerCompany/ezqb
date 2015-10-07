//
//  UploadImageCollectionViewController.swift
//  EZQB
//
//  Created by iOS Developer on 7/27/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

import UIKit

//romanso: why do you need UINavigationControllerDelegate, UINavigationBarDelegate protocols
// write an extension for "UIImagePickerControllerDelegate"
// and keep in mind !
// any extension gives you divided part of codes so your code would be more readable
class UploadImageCollectionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UINavigationBarDelegate {
    
    var userID: String?
    @IBOutlet var collection: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var disableView: UIView!
    
    private var selectedCell: UploadImageCell?
    private var imagesToUpLoad: [UIImage] = [UIImage]() //romanso: it was [UIImage]
    // i think there is no need to keep nil ptr in array
    
    // skatolyk: if I delete this appear a problems
    
    private var indexOfSelectedImageView: NSIndexPath?
    
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        println(userID)
        self.setBarButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.collection.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // romanso: I think it wpuld be nice to have an extension to
    
    // skatolyk: to what??
    func addPhoto() {
        
        let alert = UIAlertController(title: "Upload/Take a Picture", message: "Choose an option", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Open Gallery", style: .Default, handler: {
            action in self.getPhotoFromGallery("Open Gallery")
        }))
        
        alert.addAction(UIAlertAction(title: "Take a Picture", style: .Default, handler: {
            action in self.getPhotoFromGallery("Take a Picture")
        }))
        
        if self.imagesToUpLoad.isEmpty == false
            &&
            self.imagesToUpLoad.count > self.indexOfSelectedImageView!.row {
                alert.addAction(UIAlertAction(title: "Delete Photo", style: .Default, handler: {
                    action in self.imagesToUpLoad.removeAtIndex(self.indexOfSelectedImageView!.row)
                    self.collection.reloadData()
                }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //romanso: i think it not a good name of func
    // it would better to rename it to "getPhotoFromGallery"
    
    // skatolyk: Done
    
    // and another func named "getPhotoFromCamera"
    
    // skatolyk: Why do we have to create one more function with the name "getPhotoFromCamera"
    func getPhotoFromGallery(string: String) {
        
        let picker = UIImagePickerController()
        picker.delegate = self // skatolyk: that why we need UINavigationControllerDelegate, UINavigationBarDelegate protocols
        picker.allowsEditing = false
        
        if string == "Open Gallery" {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            }
        } else {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                picker.sourceType = UIImagePickerControllerSourceType.Camera
            }
        }
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    
    // MARK: - setBarButtonItem with Actions
    
    func setBarButtonItem() {
        
        let backViewControllerButton: UIBarButtonItem = UIBarButtonItem(title: "Log out",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "backToLogIn"
        )
        let uploadPhotoButton: UIBarButtonItem = UIBarButtonItem(title: "Upload",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "uploadPhoto"
        )
        
        self.navigationItem.leftBarButtonItem = backViewControllerButton //romanso: move this code below instantiating backViewControllerButton or even you can remove local let backViewControllerButton
        // skatolyk: what???
        self.navigationItem.rightBarButtonItem = uploadPhotoButton
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    func uploadPhoto() {
        self.activityIndicatorEnable(false)
        for index in 0...self.imagesToUpLoad.count - 1 {
            DataProvider.uploadPhoto(self.imagesToUpLoad[index],
                withName: "fileName\(index)") { (error) -> Void in
                    
                    if error == nil {
                        if index == self.imagesToUpLoad.count - 1 {
                            AlertView.showAlert(self,
                                title: "Success",
                                message: "All images uploaded",
                                buttonTitle: "OK"
                            )
                            self.imagesToUpLoad.removeAll(keepCapacity: true)
                            self.collection.reloadData()
                        }
                    } else {
                        print(error)
                    }
                    self.activityIndicatorEnable(true)
            }
        }
    }
    
    private func activityIndicatorEnable(bool: Bool) {
        
        self.disableView.hidden = bool
        if bool == true {
            
            self.view.bringSubviewToFront(self.collection)
            self.activityIndicator.stopAnimating()
            self.navigationItem.leftBarButtonItem?.enabled = true
        } else {
            
            self.view.bringSubviewToFront(self.disableView)
            self.activityIndicator.startAnimating()
            self.navigationItem.rightBarButtonItem?.enabled = false
            self.navigationItem.leftBarButtonItem?.enabled = false
        }
    }
    
    func backToLogIn() {
        
        Defaults.resetEmailAndPassword()
        dismissViewControllerAnimated(true, completion: nil)
    }
}


//MARK: UICollectionViewDataSource, UICollectionViewDelegate

extension UploadImageCollectionViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.imagesToUpLoad.count < 5 {
            return 5
        } else if self.imagesToUpLoad.count + 1 <= 20 {
            return self.imagesToUpLoad.count + 1
        } else {
            return 20
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UploadImageCell", forIndexPath: indexPath) as! UploadImageCell
        
        if self.imagesToUpLoad.isEmpty == false
            &&
            self.imagesToUpLoad.count > indexPath.row {
                cell.imageView.image = self.imagesToUpLoad[indexPath.row]
        } else {
            cell.imageView.image = UIImage(named: "noPhoto")
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.indexOfSelectedImageView = indexPath
        self.selectedCell = collectionView.dequeueReusableCellWithReuseIdentifier("UploadImageCell", forIndexPath: indexPath) as? UploadImageCell
        self.addPhoto()
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return CGSizeMake(self.view.frame.width / 3.2, self.view.frame.width / 3.2)
    }
    
    
    // MARK: - set image in collectionViewController
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.selectedCell!.imageView!.image = pickedImage
            
            if self.imagesToUpLoad.count > indexOfSelectedImageView!.row {
                self.imagesToUpLoad[indexOfSelectedImageView!.row] = self.selectedCell!.imageView!.image!
            } else {
                self.imagesToUpLoad.append(self.selectedCell!.imageView!.image!)
            }
            self.navigationItem.rightBarButtonItem?.enabled = true
            self.collection.reloadData()
        }
        dismissViewControllerAnimated(true, completion: nil)

    }
}
