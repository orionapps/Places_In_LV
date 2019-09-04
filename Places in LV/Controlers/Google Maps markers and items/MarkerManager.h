//
//  MarkerManager.h
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 14/08/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

#ifndef MarkerManager_h
#define MarkerManager_h

#import <Foundation/Foundation.h>
@import CoreLocation;
#import "GMUClusterItem.h"
#import <GoogleMaps/GoogleMaps.h>


@interface MarkerManager: NSObject

@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, strong) GMSMarker *marker;

@end

#endif /* MarkerManager_h */
