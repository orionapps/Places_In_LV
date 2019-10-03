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
        
        // Setting up popover
        let width = self.view.frame.width / 1.5
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.view.frame.size.height / 4))
        let options = [
          .type(.auto),
          .sideEdge(2.2),
          .animationIn(0.3),
          .blackOverlayColor(UIColor.clear),
          .arrowSize(CGSize(width: 20, height: 20))
          ] as [PopoverOption]
        let popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.show(aView, fromView: self.changeLanguageBtn)
    }
    
}
