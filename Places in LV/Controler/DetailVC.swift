//
//  DetailVC.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 12/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit
import Hero

class DetailVC: UIViewController {


    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationInfoLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    
    var locationName: String = ""
    var locationInfo: String = ""
    var locationImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
       self.locationNameLabel.text = locationName
       self.locationNameLabel.hero.id = "\(locationName)_name"
       self.locationInfoLabel.text = locationInfo
       self.locationImageView.image = locationImage
        self.locationImageView.hero.id = "\(locationImage)_image"
        
       //self.locationImageView.hero.id =
       //self.locationImageView.hero.modifiers = [.zPosition(2)]
       //self.locationNameLabel.hero.id = "name"
       //self.locationNameLabel.hero.modifiers = [.zPosition(2)]

        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: locationInfoLabel.bottomAnchor).isActive = true
    }

}
