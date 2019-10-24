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

        // Do any additional setup after loading the view.
    }
    
    func uploadObjectPhoto() {

        guard let image = imageView.image,
            let data = image.jpegData(compressionQuality: 1.0) else {
                AlertService.showAlert(style: .alert, title: "Error", message: "Something went wrong")
            return
        }
        
//        if self.objectNameTxtField != nil {
//            let objectNameData = self.objectNameTxtField
//        } else {
//            AlertService.showAlert(style: .alert, title: "Error", message: "Please type object name")
//        }

        let imageName = UUID().uuidString
        let storageReference = Storage.storage().reference()
            
        storageReference.child(Constants.MyKeys.userAddedImageFolderInFirebase).child(imageName)
        
        if objectNameTxtField.text != "" && objectDescriptionTxtField.text != "" && objectWorkingHoursTxtField.text != "" {
            
            storageReference.child(Constants.MyKeys.userAddedImageFolderInFirebase).setValuesForKeys(["Object Name": objectNameTxtField.text!, "Object description": objectDescriptionTxtField.text!, "Object working hours": objectWorkingHoursTxtField.text!])
            
            objectNameTxtField.text = ""
            objectDescriptionTxtField.text = ""
            objectWorkingHoursTxtField.text = ""
            
        } else {
            
            AlertService.showAlert(style: .alert, title: "Error", message: "All fields must be filled")
        }
        
        storageReference.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                AlertService.showAlert(style: .alert, title: "Error", message: error.localizedDescription)
                return
            }
            
            storageReference.downloadURL { (url, error) in
                if let error = error {
                    AlertService.showAlert(style: .alert, title: "Error", message: error.localizedDescription)
                    return
                }
                
                guard let url = url else{
                    AlertService.showAlert(style: .alert, title: "Error", message: error?.localizedDescription)
                    return
                }
                
                let dataReference = Firestore.firestore().collection(Constants.MyKeys.imagesCollection).document()
                let documentUid = dataReference.documentID
                let urlString = url.absoluteString
                
                
                let data = [Constants.MyKeys.uid: documentUid,
                            Constants.MyKeys.imageUrl: urlString]
                
                dataReference.setData(data) { (error) in
                    if let error = error {
                        AlertService.showAlert(style: .alert, title: "Error", message: error.localizedDescription)
                        return
                    }
                    
                    UserDefaults.standard.set(documentUid, forKey: Constants.MyKeys.uid)
                    self.imageView.image = UIImage()
                    AlertService.showAlert(style: .alert, title: "Success", message: "Image saved sucsessfully")
                    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewObjectAddingVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {
        
        let photoLibraryAction = UIAlertAction(title: "Choose from library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Take from camera", style: .default) { (action) in
                   self.showImagePickerController(sourceType: .camera)
               }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        AlertService.showAlert(style: .actionSheet, title: "Choose object photo", message: nil, actions: [photoLibraryAction, cameraAction, cancelAction], completion: nil)
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
        
        //addImageBtn.alpha = 0
        dismiss(animated: true, completion: nil)
    }
}
