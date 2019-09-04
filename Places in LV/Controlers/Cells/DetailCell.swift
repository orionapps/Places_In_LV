//
//  DetailCell.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 30/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit
import Hero

class DetailCell:  UICollectionViewCell{
    
    @IBOutlet weak var imgTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionDetailLabel: UILabel!
    @IBOutlet weak var collectionDetailImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionDetailImg.clipsToBounds = true
        configureAll()
    }
    
    
    // MARK: - Configuration
    
    private func configureAll() {
        configureCell()
    }
    
    private func configureCell() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = self.contentView.layer.cornerRadius
        
    }
}
