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

class ChooseLogInVC: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var signInWithGoogleBtn: GIDSignInButton!
    @IBOutlet weak var signInWithFacebookBtn: UIButton!
    @IBOutlet weak var signInWithTwitterBtn: UIButton!
    @IBOutlet weak var signInWithEmailBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    
    func setUpView() {
        
        signInWithGoogleBtn.layer.cornerRadius = 25.0
        signInWithGoogleBtn.tintColor = UIColor.black
        signInWithGoogleBtn.backgroundColor = UIColor.white
        
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
    
    
    @IBAction func signInWithGooglePressed(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
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
            print("logged ins sucsessfuly")
            self.transitionToMaps()
        }
    }
    
    
    func transitionToMaps() {
        
        let mapsVC =  storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mapsVC) as? ContainerView
        
        view.window?.rootViewController = mapsVC
        view.window?.makeKeyAndVisible()
    }

}


