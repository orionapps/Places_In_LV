//
//  Helper.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 08/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import LanguageManager_iOS


// Version 1 color scheme: 9E3039 & 0B4F6C & 01BAEF & FBFBFF & 040F16
let imageCache = NSCache<NSString, UIImage>()


class Helper: UIImageView {
    
    var imageUrlString: String?
    
    // Navigation bar color for whole app
    func navigationBarBackgroundColor() -> UIColor {
        
        return Helper().hexStringToUIColor(hex: "0B4F6C", alpha: 0.5)
    }
    
    // Navigation bar text color for the whole app
    func navigationBarTextColor() -> UIColor {
        
        return Helper().hexStringToUIColor(hex: "FBFBFF", alpha: 1)
    }
    
    // Dark blue color
    func darkBlueColor() -> UIColor {
        
        return Helper().hexStringToUIColor(hex: "195D7A", alpha: 1)
    }
    
    
    func hexStringToUIColor (hex:String, alpha: Float) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    //Activity indicator methods
    
    func startActivityIndicator(view: UIView, activityIndicator: UIActivityIndicatorView) {
        
        activityIndicator.center = view.center
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = Helper().navigationBarBackgroundColor()
        view.addSubview(activityIndicator)
        activityIndicator .startAnimating()
        //UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    //Cache images
    
    func stopActivityIndicator (activityIndicator: UIActivityIndicatorView) {
        
        activityIndicator.stopAnimating()
        //UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
    func transitionToMaps(view: UIView) {
        
        let mapStoryboard : UIStoryboard = UIStoryboard(name: "Map", bundle: nil)
        let mapsVC =  mapStoryboard.instantiateViewController(withIdentifier: Constants.Storyboard.mapsVC) as! ContainerView
        
        view.window?.rootViewController = mapsVC
        view.window?.makeKeyAndVisible()
    }
    
    //Change Language
    
    func changeLanguage(to requiredLanguage: Languages) {
        
        let storyboard = UIStoryboard(name: "Map", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        
        LanguageManager.shared.setLanguage(language: requiredLanguage, rootViewController: vc) { view in
            view.transform = CGAffineTransform(scaleX: 2, y: 2)
            view.alpha = 0
        }
    }
}

