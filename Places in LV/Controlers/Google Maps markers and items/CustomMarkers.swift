//
//  CustomMarkers.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 15/08/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import Foundation

class CustomMarkers: GMUDefaultClusterRenderer {
    var mapView:GMSMapView?
    let kGMUAnimationDuration: Double = 0.5
    
    override init(mapView: GMSMapView, clusterIconGenerator iconGenerator: GMUClusterIconGenerator) {
        
        super.init(mapView: mapView, clusterIconGenerator: iconGenerator)
    }
    
    
    func markerWithPosition(position: CLLocationCoordinate2D, from: CLLocationCoordinate2D, userData: AnyObject, clusterIcon: UIImage, animated: Bool) -> GMSMarker {
        let initialPosition = animated ? from : position
        let marker = GMSMarker(position: initialPosition)
        marker.userData! = userData
        if clusterIcon.cgImage != nil {
            marker.icon = clusterIcon
        }
        else {
            marker.icon = self.getCustomTitleItem(userData: userData)
            
        }
        marker.map = mapView
        if animated
        {
            CATransaction.begin()
            CAAnimation.init().duration = kGMUAnimationDuration
            marker.layer.latitude = position.latitude
            marker.layer.longitude = position.longitude
            CATransaction.commit()
        }
        return marker
    }
    
    
    func getCustomTitleItem(userData: AnyObject) -> UIImage {
        let item = userData as! POIItem
        return item.marker.icon!
    }
}
