//
//  SettingsVC.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 08/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var changeLanguageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    func setUpView() {
        
        Utilities.styleHollowButton(changeLanguageBtn)
    }
    
    
    @IBAction func changeLanguagePressed(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: "Mainīt valodu", message:nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Atcelt", style: .cancel, handler: nil)
        
        let latvianLanguage = UIAlertAction(title: "Latviešu", style: .default) { action in
            
            print("LV language selected")
        }
        
        let russianLanguage = UIAlertAction(title: "Русский", style: .default) { action in
            
            print("RU language selected")
        }
        
        let englishLanguage = UIAlertAction(title: "English", style: .default) { action in
            
            print("ENG language selected")
        }
        
        actionSheet.addAction(cancel)
        actionSheet.addAction(latvianLanguage)
        actionSheet.addAction(russianLanguage)
        actionSheet.addAction(englishLanguage)
        
        present(actionSheet, animated: true, completion: nil)

    }
    
}
