//
//  Constants.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 04/09/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Storyboard {
        
        static let mapsVC = "MapsVC"
        static let authVC = "AuthVC"
    }
    
    struct ErrorMessages {
        
        static let internetConnectionErrorTitle = "Failed to load info"
        static let internetConnectionErrorMessage = "Please check your internet connection and try again"
        static let error = "Error"
        static let allFieldsMustBeFilled = "All fields must be filled"
        static let pleaseAddPhoto = "Please add photo"
    }
    
    struct FrequentlyUsedMessages {
        
        static let cancel = "Cancel"
    }
    
    struct MyKeys {
        static let imageFolderInFirebase = "Objects"
        static let userAddedImageFolderInFirebase = "userUploadedObjects"
        static let uid = "uid"
        static let imageUrl = "imageUrl"
        static let imagesCollection = "imagesCollection"
    }
}
