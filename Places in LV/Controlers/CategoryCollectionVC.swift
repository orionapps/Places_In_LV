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

var categoriesArray = ["Sightseeings", "Nature And Parks", "Museums", "Playgrounds", "Outdoor Sports"]
var categoryImageNames = ["Sightseeings", "ParksAndNature", "Museums", "Playgrounds", "Sports"]

var parallaxOffsetSpeed = 30
var cellHeight: CGFloat = 172


class CategoryCollectionVC: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cell.categoryLabel.text = categoriesArray[indexPath.row]
    
        return cell
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "CategoryCollection", bundle: nil)
        let destVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailCollectionVC") as! DetailCollectionVC
        
        for location in allLocations {
            
            if indexPath.row == 0 && location.locationID == 0{
                
                destVC.locationNamesArray.append(location.locationName)
                destVC.locationInfoArray.append(location.locationInfo)
                destVC.locationLatitude.append(location.lat)
                destVC.locationLongitude.append(location.long)
                
                if let locationPhotos = location.placePhoto {
                    destVC.locationImage.append(locationPhotos)
                }
                
                if let locationOpeningHours = location.openingHours {
                    destVC.openingHours.append(locationOpeningHours)
                }
            } else if indexPath.row == 1 && location.locationID == 1{
                
                destVC.locationNamesArray.append(location.locationName)
                destVC.locationInfoArray.append(location.locationInfo)
                destVC.locationLatitude.append(location.lat)
                destVC.locationLongitude.append(location.long)
                
                if let locationPhotos = location.placePhoto {
                    destVC.locationImage.append(locationPhotos)
                }
                
                if let locationOpeningHours = location.openingHours {
                    destVC.openingHours.append(locationOpeningHours)
                }
            } else if indexPath.row == 2 && location.locationID == 2{
                
                destVC.locationNamesArray.append(location.locationName)
                destVC.locationInfoArray.append(location.locationInfo)
                destVC.locationLatitude.append(location.lat)
                destVC.locationLongitude.append(location.long)
                
                if let locationPhotos = location.placePhoto {
                    destVC.locationImage.append(locationPhotos)
                }
                
                if let locationOpeningHours = location.openingHours {
                    destVC.openingHours.append(locationOpeningHours)
                }
            } else if indexPath.row == 3 && location.locationID == 3{
                
                destVC.locationNamesArray.append(location.locationName)
                destVC.locationInfoArray.append(location.locationInfo)
                destVC.locationLatitude.append(location.lat)
                destVC.locationLongitude.append(location.long)
                
                if let locationPhotos = location.placePhoto {
                    destVC.locationImage.append(locationPhotos)
                }
                
                if let locationOpeningHours = location.openingHours {
                    destVC.openingHours.append(locationOpeningHours)
                }
            } else if indexPath.row == 4 && location.locationID == 4{
                
                destVC.locationNamesArray.append(location.locationName)
                destVC.locationInfoArray.append(location.locationInfo)
                destVC.locationLatitude.append(location.lat)
                destVC.locationLongitude.append(location.long)
                
                if let locationPhotos = location.placePhoto {
                    destVC.locationImage.append(locationPhotos)
                }
                
                if let locationOpeningHours = location.openingHours {
                    destVC.openingHours.append(locationOpeningHours)
                }
            }
            
        }
        self.navigationController?.pushViewController(destVC, animated: true)
    }


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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
