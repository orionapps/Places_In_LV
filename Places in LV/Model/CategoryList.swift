//
//  LocationDataModel.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 10/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import Foundation

struct CategoryList: Decodable {

    var locationID: Int
    var locationName: String
    var lat: Double
    var long: Double
    var locationInfo: String
    var placePhoto: String?
    var openingHours: String?
    var descriptionArbitration: String?
    var imageArbitration: String?
}

// Sightseeings locationID - 0
// Museums locationID - 1
// Nature and Parks locationID = 2
// Playgrounds locationID = 3
// sportsPlaygrounds locationID = 4
// Castles and Mansons locationID = 5
