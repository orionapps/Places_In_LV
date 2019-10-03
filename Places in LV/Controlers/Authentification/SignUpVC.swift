//
//  SignUpVC.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 04/09/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpVC: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }
    
    func setUpElements() {
        
        //Hide the error label
        errorLabel.alpha = 0
        
        // Style the element
        Utilities.styleTextField(firstNameTextField, withText: "First Name")
        Utilities.styleTextField(lastNameTextField, withText: "Last Name")
        Utilities.styleTextField(emailTextField, withText: "Email")
        Utilities.styleTextField(passwordTextField, withText: "Password")
        Utilities.styleFilledButton(signInBtn)
    }
    
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message.
    func validateFields() -> String? {
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        let cleanPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanPassword) == false {
            return "Please make sure you password is at least 8 characters, and contains a number"
        }
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        
        // Validate the fields
        
        let error = validateFields()
        
        if error != nil {
            
            showError(error!)
        } else {
            
            let firstName = self.firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = self.lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = self.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (results, error) in
                
                if error != nil {
                    
                    if error?.localizedDescription == "The email address is already in use by another account." {
                        self.showError("The email address is already in use by another account.")
                    } else {
                        self.showError("Error creating user")
                    }
                    
                    print(error?.localizedDescription as Any)
                } else {
                    
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["first_name":firstName, "last_name":lastName, "uid":results!.user.uid], completion: { (error) in
                        
                        if error != nil {
                            self.showError("Error saving user data")
                        }
                    })
                    Helper().transitionToMaps(view: self.view)
                }
            }
        }
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
