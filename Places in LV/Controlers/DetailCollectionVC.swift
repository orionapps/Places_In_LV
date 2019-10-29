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
        
        if Reachability.isConnectedToNetwork() {
            
            let storageRef = Storage.storage().reference(withPath: "Objects/\((locationImage[indexPath.row])).jpg")
            storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                
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
            
            let alert = UIAlertController(title: Constants.ErrorMessages.internetConnectionErrorTitle.localiz(), message: Constants.ErrorMessages.internetConnectionErrorMessage.localiz(), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        cell.collectionDetailImg.hero.modifiers = [.zPosition(2)]
        cell.imgHightConstraint.constant = self.parallaxImageHeight
        cell.imgTopConstraint.constant = parallaxOffset(newOffsetY: collectionView.contentOffset.y, cell: cell)
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        Helper().startActivityIndicator(view: self.view, activityIndicator: activityIndicator)
        
        if Reachability.isConnectedToNetwork() {
            
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Detail", bundle: nil)
            let destVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
            
            destVC.locationName = self.locationNamesArray[indexPath.item]
            destVC.locationInfo = self.locationInfoArray[indexPath.item]
            destVC.locationLatitude = self.locationLatitude[indexPath.item]
            destVC.locationLongitude = self.locationLongitude[indexPath.item]
            destVC.openingHours = self.openingHours[indexPath.item]
            
            let storageRef = Storage.storage().reference(withPath: "Objects/\((locationImage[indexPath.row])).jpg")
            storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
                if let error = error {
                    print("Got an error fetching data: \(error.localizedDescription)")
                    return
                }
                
                if let data = data {
                    
                    destVC.locationImage = UIImage(data: data)!
                    Helper().stopActivityIndicator(activityIndicator: self!.activityIndicator)
                    self!.navigationController?.pushViewController(destVC, animated: true)
                }
            }
        } else {
            
            Helper().stopActivityIndicator(activityIndicator: activityIndicator)
            
            let alert = UIAlertController(title: Constants.ErrorMessages.internetConnectionErrorTitle.localiz(), message: Constants.ErrorMessages.internetConnectionErrorMessage.localiz(), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Collection cells paralax methods
    
    var parallaxImageHeight: CGFloat {
        
        let maxOffset = (sqrt(pow(cellHeight, 2) + 4 * parallaxOffsetSpeed * self.collectionView.frame.height) - cellHeight) / 2
        
        return maxOffset + self.cellHeight
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


