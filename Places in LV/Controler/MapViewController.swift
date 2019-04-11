//
//  MapViewController.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 02/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData


class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!

    // Constants
    var locationManager = CLLocationManager()
    var locationsModel = [CategoryList]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showCategories),
                                               name: NSNotification.Name(rawValue: "showCategories"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showSortBySeasons),
                                               name: NSNotification.Name(rawValue: "showSortBySeasons"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showSettings),
                                               name: NSNotification.Name(rawValue: "showSettings"),
                                               object: nil)
        
        
        // Preload data
        guard let urlPath = Bundle.main.url(forResource: "PreloadedData", withExtension: "json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: urlPath)
            let locations = try JSONDecoder().decode(CategoryList.self, from: data)
            locationsModel.append(locations)
            
            for location in locations.Sightseengs!{
                
                let lat = location.lat
                let long = location.long
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                marker.title = location.locationName
                marker.map = mapView
            }
            
            
            
            //print(locations.Sightseengs![2].locationName)
            
//            for allLocations in locations.Sightseengs! {
//
//                //print(locations.Sightseengs![0].locationName)
//                print(allLocations.locationName)
//            }

        } catch {
            print(error)
        }
        
        
        
        
 
        
        

    }
    
    @objc func showCategories() {
        
        performSegue(withIdentifier: "showCategories", sender: nil)
    }
    
    @objc func showSortBySeasons() {
        
        performSegue(withIdentifier: "showSortBySeasons", sender: nil)
    }
    
    @objc func showSettings() {
        
        performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    
    //MARK: - Location manager delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 14)
        mapView.animate(to: camera)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Side Menu bar functions and actions

    @IBAction func openMenuView(_ sender: UIBarButtonItem) {
        
        NotificationCenter.default.post(name: Notification.Name("ToggleSideMenu"), object: nil)
    }
    
}

