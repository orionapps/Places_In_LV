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

class ChooseLogInVC: UIViewController, GIDSignInDelegate, LoginButtonDelegate {
    
    
    @IBOutlet weak var signInWithGoogleBtn: GIDSignInButton!
    @IBOutlet weak var signInWithFacebookBtn: UIButton!
    @IBOutlet weak var signInWithTwitterBtn: UIButton!
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
        
        signInWithTwitterBtn.layer.cornerRadius = 25.0
        signInWithTwitterBtn.tintColor = UIColor.white
        signInWithTwitterBtn.backgroundColor = Helper().hexStringToUIColor(hex: "3283E0", alpha: 1.0)
        
        signInWithEmailBtn.layer.cornerRadius = 25.0
        signInWithEmailBtn.tintColor = UIColor.white
        signInWithEmailBtn.backgroundColor = Helper().hexStringToUIColor(hex: "c4041F", alpha: 1.0)
    }
    
    
    // MARK: - Google sign in methods
    @IBAction func signInWithGooglePressed(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    
    //MARK: - Facebook sign in methods
    @objc func handleCustomFBLogin(){
        
        LoginManager().logIn(permissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print("Custom Facebook Login failed")
                return
            }
            self.showEmailAddress()
            self.transitionToMaps()
        }
    }
    
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
    
    
    //MARK: - Transition to Maps
    
    func transitionToMaps() {
        
        let mapsVC =  storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mapsVC) as? ContainerView
        
        view.window?.rootViewController = mapsVC
        view.window?.makeKeyAndVisible()
    }
}


