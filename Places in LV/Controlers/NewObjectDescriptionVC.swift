//
//  NewObjectDescriptionVC.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 28/10/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore


class NewObjectDescriptionVC: UIViewController {
    
    @IBOutlet weak var objectNameTxtField: UITextField!
    @IBOutlet weak var objectDescriptionTxtField: UITextField!
    @IBOutlet weak var objectWorkingHoursTxtField: UITextField!
    @IBOutlet var categoryCollection: [UIButton]!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var selectCategoryBtn: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var pickedImage: UIImage!
    var objectCategory: String = ""
    var tappedLatitude: String = ""
    var tappedLongitude: String = ""
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    //MARK: - View set up
    
    func setUpView() {
        
        self.backgroundImageView.image = pickedImage
        
        Utilities.styleFilledButton(submitBtn)
        Utilities.styleDarkFilledButton(selectCategoryBtn)
        
        categoryCollection.forEach { (categoryItem) in
            
            Utilities.styleFilledButton(categoryItem)
        }
    }
    
    //MARK: - Networking
    
    func uploadObjectData() {
        
        Helper().startActivityIndicator(view: self.view, activityIndicator: activityIndicator)
        
        let imageName = UUID().uuidString
        let textName = UUID().uuidString
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        // Uploading json for Object name, description and working hours to firebase storage
        if objectNameTxtField.text != "" && objectDescriptionTxtField.text != "" && objectWorkingHoursTxtField.text != "" && objectCategory != "" && tappedLatitude != "" && tappedLongitude != "" {
            
            let textObjectRef = storageRef.child(Constants.MyKeys.userAddedImageFolderInFirebase).child(objectNameTxtField.text! + "-" + textName)
            
            let objectName = String(describing: objectNameTxtField.text)
            let objectDescription = String(describing: objectDescriptionTxtField.text)
            let objectWorkingHours = String(describing: objectWorkingHoursTxtField.text)
            
            let newObjectDict = ["Image UUID" : imageName ,"Latitude" : tappedLatitude,"Longitude" : tappedLongitude ,"Object Category": objectCategory,"Object Name": objectName, "Object description": objectDescription, "Object working hours": objectWorkingHours]
            
            let jsonData = try! JSONSerialization.data(withJSONObject: newObjectDict, options: .prettyPrinted)
            
            textObjectRef.putData(jsonData, metadata: nil) { (metadata, error) in
                if let error = error {
                    
                    Helper().stopActivityIndicator(activityIndicator: self.activityIndicator)
                    AlertService.showAlert(style: .alert, title: Constants.ErrorMessages.error.localiz(), message: error.localizedDescription)
                    return
                }
            }
        } else {
            
            Helper().stopActivityIndicator(activityIndicator: self.activityIndicator)
            AlertService.showAlert(style: .alert, title: Constants.ErrorMessages.error.localiz(), message: Constants.ErrorMessages.allFieldsMustBeFilled.localiz())
            return
        }
        
        
        // Uploading object photo to firebase storage
        
        let data = pickedImage.jpegData(compressionQuality: 1.0)
        
        let imageObjectRef = storageRef.child(Constants.MyKeys.userAddedImageFolderInFirebase).child(objectNameTxtField.text! + "-" + imageName)
        
        imageObjectRef.putData(data!, metadata: nil) { (metadata, error) in
            if let error = error {
                Helper().stopActivityIndicator(activityIndicator: self.activityIndicator)
                AlertService.showAlert(style: .alert, title: Constants.ErrorMessages.error.localiz(), message: error.localizedDescription)
                return
            }
            
            imageObjectRef.downloadURL { (url, error) in
                if let error = error {
                    Helper().stopActivityIndicator(activityIndicator: self.activityIndicator)
                    AlertService.showAlert(style: .alert, title: Constants.ErrorMessages.error.localiz(), message: error.localizedDescription)
                    return
                }
                
                guard let url = url else{
                    Helper().stopActivityIndicator(activityIndicator: self.activityIndicator)
                    AlertService.showAlert(style: .alert, title: Constants.ErrorMessages.error.localiz(), message: error?.localizedDescription)
                    return
                }
                
                let dataReference = Firestore.firestore().collection(Constants.MyKeys.imagesCollection).document()
                let documentUid = dataReference.documentID
                let urlString = url.absoluteString
                
                
                let data = [Constants.MyKeys.uid: documentUid,
                            Constants.MyKeys.imageUrl: urlString]
                
                dataReference.setData(data) { (error) in
                    if let error = error {
                        Helper().stopActivityIndicator(activityIndicator: self.activityIndicator)
                        AlertService.showAlert(style: .alert, title: Constants.ErrorMessages.error.localiz(), message: error.localizedDescription)
                        return
                    }
                    
                    UserDefaults.standard.set(documentUid, forKey: Constants.MyKeys.uid)
                    self.pickedImage = UIImage()
                    
                    let done = "Done"
                    let success = "Success"
                    let successfullyUploadedDataMessage = "Your object information has been sent and will be reviewed by our team soon. Please be aware that Explore Latvia team can refuse including your object on the map in case it contains inaccurate or inappropriate data."
                    
                    Helper().stopActivityIndicator(activityIndicator: self.activityIndicator)
                    
                    // Alert view if success
                    let ok = UIAlertAction(title: done.localiz(), style: .default) { action in
                        
                        self.navigationController?.popToRootViewController(animated: false)
                    }
                    
                    AlertService.showAlert(style: .alert, title: success.localiz(), message: successfullyUploadedDataMessage.localiz(), actions: [ok]) {
                    }
                }
            }
        }
    }
    
    //MARK: - Action methods
    
    @IBAction func selectCategoryPressed(_ sender: UIButton) {
        
        categoryCollection.forEach { (categoryItem) in
            
            UIView.animate(withDuration: 0.3) {
                categoryItem.isHidden = !categoryItem.isHidden
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    @IBAction func categoryItemPressed(_ sender: UIButton) {
        
        guard let title = sender.currentTitle else {return}
        
        self.objectCategory = title
        print(self.objectCategory)
        
        categoryCollection.forEach { (categoryItem) in
            
            UIView.animate(withDuration: 0.3) {
                self.selectCategoryBtn.setTitle(title, for: .normal)
                self.selectCategoryBtn.setImage(nil, for: .normal)
                categoryItem.isHidden = !categoryItem.isHidden
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    @IBAction func submitPressed(_ sender: UIButton) {
        
        uploadObjectData()
    }
}

