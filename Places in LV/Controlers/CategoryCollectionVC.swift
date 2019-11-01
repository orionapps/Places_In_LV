//
//  CategoryCollectionVC.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 25/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CategoryCell"
var allLocations = [CategoryList]()

var categoriesArray = ["Sightseeings", "Nature And Parks", "Museums", "Playgrounds", "Outdoor Sports", "Castles and Manors"]
var categoryImageNames = ["Sightseeings", "ParksAndNature", "Museums", "Playgrounds", "Sports", "Castles"]

var parallaxOffsetSpeed = 30
var cellHeight: CGFloat = 172


class CategoryCollectionVC: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Helper().navigationBarBackgroundColor()
        self.view.backgroundColor?.withAlphaComponent(0.7)
        fetchData()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoriesArray.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
        
        cell.categoryBackgroundImg.image = UIImage(named: categoryImageNames[indexPath.row])
        cell.categoryLabel.text = categoriesArray[indexPath.row].localiz()
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            appendDataWith(locationID: 0)
        } else if indexPath.row == 1 {
            
            appendDataWith(locationID: 1)
        } else if indexPath.row == 2 {
            
            appendDataWith(locationID: 2)
        } else if indexPath.row == 3 {
            
            appendDataWith(locationID: 3)
        } else if indexPath.row == 4 {
            
            appendDataWith(locationID: 4)
        } else if indexPath.row == 5 {
            
            appendDataWith(locationID: 5)
        }
    }
    
    
    func appendDataWith(locationID: Int) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "CategoryCollection", bundle: nil)
        let destVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailCollectionVC") as! DetailCollectionVC
        
        for location in allLocations {
            
            if location.locationID == locationID {
                
                destVC.locationNamesArray.append(location.locationName)
                destVC.locationInfoArray.append(location.locationInfo)
                destVC.locationLatitude.append(location.lat)
                destVC.locationLongitude.append(location.long)
                
                if let imageArbitration = location.imageArbitration {
                    destVC.imageArbitration.append(imageArbitration)
                } else {
                    destVC.imageArbitration.append("")
                }
                
                if let descriptionArbitration = location.descriptionArbitration {
                    destVC.descriptionArbitration.append(descriptionArbitration)
                } else {
                    destVC.descriptionArbitration.append("")
                }
                
                if let locationPhotos = location.placePhoto {
                    destVC.locationImage.append(locationPhotos)
                } else {
                    destVC.locationImage.append("standartImage")
                }
                
                if let locationOpeningHours = location.openingHours {
                    destVC.openingHours.append(locationOpeningHours)
                } else {
                    destVC.openingHours.append("Unknown")
                }
            }
        }
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    //MARK: - Networking
    
    func fetchData() {
        
        guard let urlPath = Bundle.main.url(forResource: "Data", withExtension: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: urlPath)
            allLocations = try JSONDecoder().decode(Array<CategoryList>.self, from: data)
        } catch {
            print(error)
        }
    }
    
}
