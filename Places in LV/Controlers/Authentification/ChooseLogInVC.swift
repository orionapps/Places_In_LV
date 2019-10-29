//
//  ChooseLogInVC.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 05/09/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class ChooseLogInVC: UIViewController, LoginButtonDelegate {
    
    @IBOutlet weak var signInWithGoogleBtn: GIDSignInButton!
    @IBOutlet weak var signInWithFacebookBtn: UIButton!
    @IBOutlet weak var signInWithEmailBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    //MARK: - Seting up view
    
    func setUpView() {
        
        signInWithGoogleBtn.layer.cornerRadius = 25.0
        signInWithGoogleBtn.tintColor = UIColor.black
        signInWithGoogleBtn.backgroundColor = UIColor.white
        
        signInWithFacebookBtn.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        signInWithFacebookBtn.layer.cornerRadius = 25.0
        signInWithFacebookBtn.tintColor = UIColor.white
        signInWithFacebookBtn.backgroundColor = Helper().hexStringToUIColor(hex: "2A4383", alpha: 1.0)
        
        
        signInWithEmailBtn.layer.cornerRadius = 25.0
        signInWithEmailBtn.tintColor = UIColor.white
        signInWithEmailBtn.backgroundColor = Helper().hexStringToUIColor(hex: "c4041F", alpha: 1.0)
    }
    
    // MARK: - Google sign in methods
    
    @IBAction func signInWithGooglePressed(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    //MARK: - Facebook sign in methods
    
    @objc func handleCustomFBLogin(){
        
        LoginManager().logIn(permissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print("Custom Facebook Login failed")
                return
            }
            self.showEmailAddress()
            Helper().transitionToMaps(view: self.view)
        }
    }
    
    //MARK: - Button methods
    
    func showEmailAddress() {
        
        GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
            if error != nil {
                print("Failed to start graph request", error as Any)
                return
            }
            print(result as Any)
        }
    }
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error as Any)
            return
        }
        print("Successfully logged in with facebook")
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("did log out of facebook")
    }
}


