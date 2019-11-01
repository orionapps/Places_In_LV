//
//  POIItem.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 15/08/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import Foundation


class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String
    @objc var marker: GMSMarker
    var image: String?
    var locationInfo: String
    var lat: Double
    var long: Double
    var openingHours: String?
    var descriptionArbitration: String?
    var imageArbitration: String?
    
    
    init(position: CLLocationCoordinate2D, name: String, marker: GMSMarker, image: String?, locationInfo: String, lat: Double, long: Double, openingHours: String?, imageArbitration: String?, descriptionArbitration: String?) {
        self.position = position
        self.name = name
        self.marker = marker
        self.image = image
        self.locationInfo = locationInfo
        self.lat = lat
        self.long = long
        self.openingHours = openingHours
        self.imageArbitration = imageArbitration
        self.descriptionArbitration = descriptionArbitration
    }
}
