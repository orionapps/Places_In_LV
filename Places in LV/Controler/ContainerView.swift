//
//  ContainerView.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 08/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit

class ContainerView: UIViewController {

    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    
    var sideMenuOpen = false
    let screenSize:CGRect = UIScreen.main.bounds
    //    var sideMenuWidth: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(toggleSideMenu),
                                               name: NSNotification.Name(rawValue: "ToggleSideMenu"),
                                               object: nil)
    }
    
    @objc func toggleSideMenu() {
        
        if sideMenuOpen {
            
            sideMenuOpen = false
            sideMenuConstraint.constant = -250
            
            
        } else {
            
            sideMenuOpen = true
            sideMenuConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //    func setUpSideMenuWidth() {
    //
    //        self.mapView.bringSubviewToFront(self.sideMenuView)
    //        //self.sideMenuView.sendSubviewToBack(self.mapView)
    //
    //
    //        sideMenuWidth = screenSize.width * 0.7
    //        self.widthSideMenuConstraint.constant = sideMenuWidth
    //        self.leadingConstraint.constant = -sideMenuWidth
    //        self.sideMenuView.layoutIfNeeded()
    //    }
    //

}
