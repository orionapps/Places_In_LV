//
//  ChooseLogInVC.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 05/09/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit

class ChooseLogInVC: UIViewController {
    @IBOutlet weak var signInWithGoogleBtn: UIButton!
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

}
