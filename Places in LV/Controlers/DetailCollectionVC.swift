//
//  DetailCollectionVC.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 26/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit
import Hero
import FirebaseStorage

class DetailCollectionVC: UICollectionViewController {
    
    var locationNamesArray = [String]()
    var locationInfoArray = [String]()
    var locationImage = [String]()
    var resizedImage = [UIImage]()
    var locationLatitude = [Double] ()
    var locationLongitude = [Double] ()
    var openingHours = [String]()
    
    var cellHeight: CGFloat = 370
    var parallaxOffsetSpeed: CGFloat = 40
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    var parallaxImageHeight: CGFloat {
        
        let maxOffset = (sqrt(pow(cellHeight, 2) + 4 * parallaxOffsetSpeed * self.collectionView.frame.height) - cellHeight) / 2
        
        return maxOffset + self.cellHeight
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return locationNamesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as! DetailCell
        
        cell.collectionDetailLabel.text = locationNamesArray[indexPath.item]
        cell.collectionDetailLabel.hero.id = "(\(indexPath.item)_name)"
        cell.collectionDetailLabel.adjustsFontSizeToFitWidth = true
        cell.collectionDetailLabel.hero.modifiers = [.zPosition(4)]
        
        
//        if let path = Bundle.main.path(forResource: locationImage[indexPath.row], ofType: "jpg"){
//
//            let image = UIImage(contentsOfFile: path)
//            //cell.collectionDetailImg.image =  self.resizeImage(image: image!, targetSize: CGSize(width: 400.0, height: 600.0))
//
//            cell.collectionDetailImg.image = image
//
//            cell.collectionDetailImg.hero.id = "\(String(describing: UIImage(named: locationImage[indexPath.item])))_image"
//        }
        
        
        
        if Reachability.isConnectedToNetwork() {
            
            let storageRef = Storage.storage().reference(withPath: "Objects/\((locationImage[indexPath.row])).jpg")
            storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
                
                if let error = error {
                    print("Got an error fetching data: \(error.localizedDescription)")
                    return
                }

                if let data = data {

                    DispatchQueue.main.async {

                        let pictures = UIImage(data: data)!
                        cell.collectionDetailImg.image = pictures
                    }
                }
            }

        } else {
            
            Helper().stopActivityIndicator(activityIndicator: activityIndicator)
            
            let alert = UIAlertController(title: "Faild to load info", message: "Please check your internet connection and try again", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        cell.collectionDetailImg.hero.modifiers = [.zPosition(2)]
        
        cell.imgHightConstraint.constant = self.parallaxImageHeight
        cell.imgTopConstraint.constant = parallaxOffset(newOffsetY: collectionView.contentOffset.y, cell: cell)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        destVC.locationName = locationNamesArray[indexPath.item]
        destVC.locationInfo = locationInfoArray[indexPath.item]
        destVC.locationLatitude = locationLatitude[indexPath.item]
        destVC.locationLongitude = locationLongitude[indexPath.item]
        destVC.openingHours = openingHours[indexPath.item]
        
        Helper().startActivityIndicator(view: self.view, activityIndicator: activityIndicator)
        
        if Reachability.isConnectedToNetwork() {
            
            let storageRef = Storage.storage().reference(withPath: "Objects/\((locationImage[indexPath.row])).jpg")
            storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
                if let error = error {
                    print("Got an error fetching data: \(error.localizedDescription)")
                    return
                }
                
                if let data = data {
                    
                    destVC.locationImage = UIImage(data: data)!
                    Helper().stopActivityIndicator(activityIndicator: self!.activityIndicator)
                    self!.present(destVC, animated: true, completion: nil)
                }
            }
        } else {
            
            Helper().stopActivityIndicator(activityIndicator: activityIndicator)
            
            let alert = UIAlertController(title: "Faild to load info", message: "Please check your internet connection and try again", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func parallaxOffset(newOffsetY: CGFloat, cell: UICollectionViewCell) -> CGFloat {
        
        return (newOffsetY - cell.frame.origin.y) / parallaxImageHeight * parallaxOffsetSpeed
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        for cell in collectionView.visibleCells as! [DetailCell] {
            cell.imgTopConstraint.constant = parallaxOffset(newOffsetY: collectionView.contentOffset.y, cell: cell)
        }
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


