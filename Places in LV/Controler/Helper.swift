//
//  Helper.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 08/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import Foundation
import UIKit

// Version 1 color scheme: 9E3039 & 0B4F6C & 01BAEF & FBFBFF & 040F16


class Helper {
    
    
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
}
