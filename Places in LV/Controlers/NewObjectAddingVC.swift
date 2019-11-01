//
//  NewObjectAddingVC.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 24/10/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class NewObjectAddingVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    
    var tappedLatitude: String = ""
    var tappedLongitude: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    //MARK: - Setting up view
    
    func setUpView() {
        
        if nextBtn.titleLabel?.text == "Next" {
            
            imageView.image = UIImage(named: "addImageEng")
        } else if nextBtn.titleLabel?.text == "Далее" {
            
            imageView.image = UIImage(named: "addImageRus")
        } else if nextBtn.titleLabel?.text == "Tālāk" {
            
            imageView.image = UIImage(named: "addImageLv")
        }
        
        Utilities.styleFilledButton(nextBtn)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDescriptionVC" {
            
            let destVC = segue.destination as! NewObjectDescriptionVC
            
            if let image = imageView.image {
                destVC.pickedImage = image
                destVC.tappedLatitude = self.tappedLatitude
                destVC.tappedLongitude = self.tappedLongitude
                
            } else {
                AlertService.showAlert(style: .alert, title: Constants.ErrorMessages.error.localiz(), message: Constants.ErrorMessages.pleaseAddPhoto.localiz())
            }
        }
    }
}



//MARK: - Extension

extension NewObjectAddingVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
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
        //imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            imageView.contentMode = .scaleAspectFill
            imageView.image = editedImage
            imageView.alpha = 1.0
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageView.contentMode = .scaleAspectFill
            imageView.image = originalImage
            imageView.alpha = 1.0
        }
        dismiss(animated: true, completion: nil)
    }
}
