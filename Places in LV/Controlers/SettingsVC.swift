//
//  SettingsVC.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 08/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit
import LanguageManager_iOS

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
        
        let title = "Change Language"
        let cancelTitle = "Cancel"
        
        let actionSheet = UIAlertController(title: title.localiz(), message:nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: cancelTitle.localiz(), style: .cancel, handler: nil)
        
        let latvianLanguage = UIAlertAction(title: "Latviešu", style: .default) { action in
            
            Helper().changeLanguage(to: .lv)
        }
        
        let russianLanguage = UIAlertAction(title: "Русский", style: .default) { action in
            
            Helper().changeLanguage(to: .ru)
        }
        
        let englishLanguage = UIAlertAction(title: "English", style: .default) { action in
            
            Helper().changeLanguage(to: .en)
        }
        
        actionSheet.addAction(cancel)
        actionSheet.addAction(latvianLanguage)
        actionSheet.addAction(russianLanguage)
        actionSheet.addAction(englishLanguage)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
}
