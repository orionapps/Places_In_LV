//
//  ObjectPreviewView.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 20/05/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import Foundation
import UIKit

class ObjectPreviewView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var objectLabel: UILabel!
    
    var locationNamesArray = [String]()
    var locationInfoArray = [String]()
    var locationImage = [String]()
    var resizedImage = [UIImage]()
    var locationLatitude = [Double] ()
    var locationLongitude = [Double] ()
    var openingHours = [String]()
    
    
    var previewImageName = UIImage()
    var previewLabelName: String = ""

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func loadView() -> ObjectPreviewView{
        
        let customInfoWindow = Bundle.main.loadNibNamed("ObjectPreviewView", owner: self, options: nil)?[0] as! ObjectPreviewView
        
        return customInfoWindow
    }
}

