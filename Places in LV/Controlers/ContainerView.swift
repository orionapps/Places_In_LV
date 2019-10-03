//
//  ContainerView.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 08/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit

class ContainerView: UIViewController {

    
    
    @IBOutlet weak var sideMenuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuContainer: UIView!
    @IBOutlet weak var mapViewContainer: UIView!
    
    var sideMenuOpen = false
    let screenSize:CGRect = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenuLeadingConstraint.constant = -sideMenuContainer.frame.size.width
        listenToNotifications()
    }
    
    
    func listenToNotifications(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(toggleSideMenu),
                                               name: NSNotification.Name(rawValue: "ToggleSideMenu"),
                                               object: nil)
    }
    
    @objc func toggleSideMenu() {
        
        if sideMenuOpen {
            
            UserDefaults.standard.set(false, forKey: "sideMenuIsOpen")
            sideMenuLeadingConstraint.constant = -200
        } else {
            
            UserDefaults.standard.set(true, forKey: "sideMenuIsOpen")
            sideMenuLeadingConstraint.constant = 0
        }
        sideMenuOpen = !sideMenuOpen
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
