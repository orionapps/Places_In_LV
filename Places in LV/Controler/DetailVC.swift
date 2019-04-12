//
//  DetailVC.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 12/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {


    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationInfoLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    
    var locationName: String = ""
    var locationInfo: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.locationNameLabel.text = locationName
       self.locationInfoLabel.text = locationInfo
        
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: locationInfoLabel.bottomAnchor).isActive = true
    }

}
