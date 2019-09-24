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

//    func loadImageUsingCacheWithUrlString(referenceString: StorageReference) {
//
//        var pictures: UIImage
//
//        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
//
//        self.startActivityIndicator(view: self, activityIndicator: activityIndicator)
//
//        referenceString.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
//            if let error = error {
//                print("Got an error fetching data: \(error.localizedDescription)")
//                return
//            }
//
//            if let data = data {
//
//                DispatchQueue.main.async {
//
//                    pictures = UIImage(data: data)!
//                    Helper().stopActivityIndicator(activityIndicator: activityIndicator)
//                }
//            }
//        }
//        return pictures
        
        //var imageUrlString: String?
        
//        func loadImageUsingUrlString(urlString: String) {
//
//            imageUrlString = urlString
//
//            guard let url = URL(string: urlString) else { return }
//
//            image = nil
//
//            if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
//                self.image = imageFromCache
//                return
//            }
//
//            let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
//            addSubview(activityIndicator)
//            activityIndicator.startAnimating()
//            activityIndicator.center = self.center
//
//            URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
//
//                if error != nil {
//                    print(error ?? "")
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    guard let imageToCache = UIImage(data: data!) else { return }
//
//                    if self.imageUrlString == urlString {
//                        self.image = imageToCache
//                        activityIndicator.removeFromSuperview()
//                    }
//
//                    imageCache.setObject(imageToCache, forKey: urlString as NSString)
//                }
//
//            }).resume()
       //}
//    }

}

