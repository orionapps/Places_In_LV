//
//  SideMenuVC.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 08/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit

class SideMenuVC: UITableViewController {
    
    @IBOutlet var categoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        swipeLeft.direction = .left
        self.categoriesTableView.addGestureRecognizer(swipeLeft)
        
        categoriesTableView.isScrollEnabled = false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        NotificationCenter.default.post(name: Notification.Name("ToggleSideMenu"), object: nil)
        
        switch (indexPath.row) {
        case 0: NotificationCenter.default.post(name: Notification.Name("showCategories"), object: nil)
        case 1: NotificationCenter.default.post(name: Notification.Name("showSortBySeasons"), object: nil)
        case 2: NotificationCenter.default.post(name: Notification.Name("showSettings"), object: nil)
        case 3: NotificationCenter.default.post(name: Notification.Name("signOut"), object: nil)
        default: break
        }
    }
    
    @objc func swipeAction(swipe: UISwipeGestureRecognizer) {
       
        NotificationCenter.default.post(name: Notification.Name("ToggleSideMenu"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("removeAlphaView"), object: nil)
    }
}
