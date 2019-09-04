//
//  CategoryCell.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 25/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit
import Hero

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryBackgroundImg: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    var backgroundImage = UIImage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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

