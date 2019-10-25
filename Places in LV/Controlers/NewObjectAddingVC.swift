//
//  NewObjectAddingVC.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 24/10/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class NewObjectAddingVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var objectNameTxtField: UITextField!
    @IBOutlet weak var objectDescriptionTxtField: UITextField!
    @IBOutlet weak var objectWorkingHoursTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func uploadObjectPhoto() {
        
        let imageName = UUID().uuidString
        let textName = UUID().uuidString
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let imageObjectRef = storageRef.child(Constants.MyKeys.userAddedImageFolderInFirebase).child(imageName)
        let textObjectRef = storageRef.child(Constants.MyKeys.userAddedImageFolderInFirebase).child(textName)
        
        
        // Uploading json for Object name, description and working hours to firebase storage
        if objectNameTxtField.text != "" && objectDescriptionTxtField.text != "" && objectWorkingHoursTxtField.text != "" {
            
            let objectName = String(describing: objectNameTxtField.text)
            let objectDescription = String(describing: objectDescriptionTxtField.text)
            let objectWorkingHours = String(describing: objectWorkingHoursTxtField.text)
            
            let newObjectDict = ["Image UUID" : imageName ,"Object Name": objectName, "Object description": objectDescription, "Object working hours": objectWorkingHours]
            
            textObjectRef.child(Constants.MyKeys.userAddedImageFolderInFirebase).child(textName)
            
            let jsonData = try! JSONSerialization.data(withJSONObject: newObjectDict, options: .prettyPrinted)
            
            textObjectRef.putData(jsonData, metadata: nil) { (metadata, error) in
                if let error = error {
                    AlertService.showAlert(style: .alert, title: Constants.ErrorMessages.error.localiz(), message: error.localizedDescription)
                    return
                }
            }
        } else {
            
            AlertService.showAlert(style: .alert, title: Constants.ErrorMessages.error.localiz(), message: Constants.ErrorMessages.allFieldsMustBeFilled.localiz())
            return
        }
        
        
        // Uploading object photo to firebase storage
        guard let image = imageView.image,
            let data = image.jpegData(compressionQuality: 1.0) else {
                AlertService.showAlert(style: .alert, title: Constants.ErrorMessages.error.localiz(), message: Constants.ErrorMessages.pleaseAddPhoto.localiz())
                return
        }
        
        imageObjectRef.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                AlertService.showAlert(style: .alert, title: Constants.ErrorMessages.error.localiz(), message: error.localizedDescription)
                return
            }
            
            imageObjectRef.downloadURL { (url, error) in
                if let error = error {
                    AlertService.showAlert(style: .alert, title: Constants.ErrorMessages.error.localiz(), message: error.localizedDescription)
                    return
                }
                
                guard let url = url else{
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
                        AlertService.showAlert(style: .alert, title: Constants.ErrorMessages.error.localiz(), message: error.localizedDescription)
                        return
                    }
                    
                    UserDefaults.standard.set(documentUid, forKey: Constants.MyKeys.uid)
                    self.imageView.image = UIImage()
                    
                    let done = "Done"
                    let success = "Success"
                    let successfullyUploadedDataMessage = "Your object information has been sent and will be reviewed by our team soon. Please be aware that Explore Latvia team can refuse including your object on the map in case it contains inaccurate or inappropriate data."
                    
                    // Alert view if success
                    let ok = UIAlertAction(title: done.localiz(), style: .default) { action in
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    AlertService.showAlert(style: .alert, title: success.localiz(), message: successfullyUploadedDataMessage.localiz(), actions: [ok]) {
                    }
                }
            }
        }
    }
    
    @IBAction func addPhotoPressed(_ sender: UIButton) {
        
        showImagePickerControllerActionSheet()
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        
        uploadObjectPhoto()
    }
}



//MARK: - Extension 

extension NewObjectAddingVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {
        
        let chooseFromLibrary = "Choose from library"
        let photoLibraryAction = UIAlertAction(title: chooseFromLibrary.localiz(), style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        
        let takeFromCamera = "Take from camera"
        let cameraAction = UIAlertAction(title: takeFromCamera.localiz(), style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        
        let cancelAction = UIAlertAction(title: Constants.FrequentlyUsedMessages.cancel.localiz(), style: .cancel, handler: nil)
        
        let chooseObjectPhoto = "Choose object photo"
        
        AlertService.showAlert(style: .actionSheet, title: chooseObjectPhoto.localiz(), message: nil, actions: [photoLibraryAction, cameraAction, cancelAction], completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = originalImage
        }
        let changeImage = "Change Image"
        let addPhoto = "Add Image"
        
        if self.imageView != nil {
            addImageBtn.setTitle(changeImage.localiz(), for: .normal)
        } else {
            addImageBtn.setTitle(addPhoto.localiz(), for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
