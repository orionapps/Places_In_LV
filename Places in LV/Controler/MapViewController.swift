//
//  MapViewController.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 02/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreData


class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    

    // Constants
    var locationManager = CLLocationManager()
    var allLocations = CategoryList()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addStyleToMap()
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
        
        
        // Fetching data from JSON
        guard let urlPath = Bundle.main.url(forResource: "PreloadedData", withExtension: "json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: urlPath)
            self.allLocations = try JSONDecoder().decode(CategoryList.self, from: data)
            
            for location in allLocations.Sightseeings!{

                let lat = location.lat
                let long = location.long

                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                marker.title = location.locationName
                marker.icon = UIImage(named: "SightseeingsIcon")
                marker.snippet = location.locationInfo
                marker.map = mapView
            }

            for location in allLocations.Museums!{

                let lat = location.lat
                let long = location.long

                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                marker.title = location.locationName
                marker.icon = UIImage(named: "MuseumsIcon")
                marker.snippet = location.locationInfo
                marker.map = mapView
            }

            for location in allLocations.NatureAndParks!{

                let lat = location.lat
                let long = location.long

                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                marker.title = location.locationName
                marker.icon = UIImage(named: "NatureAndParksIcon")
                marker.snippet = location.locationInfo
                marker.map = mapView
            }
            
            for location in allLocations.Playgrounds!{
                
                let lat = location.lat
                let long = location.long
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                marker.title = location.locationName
                marker.icon = UIImage(named: "playgroundIcon")
                marker.snippet = location.locationInfo
                marker.map = mapView
            }
            
            for location in allLocations.sportsPlaygrounds!{
                
                let lat = location.lat
                let long = location.long
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                marker.title = location.locationName
                marker.icon = UIImage(named: "sportsIcon")
                marker.snippet = location.locationInfo
                marker.map = mapView
            }

        } catch {
            print(error)
        }

    }
    
    @objc func showCategories() {

        performSegue(withIdentifier: "showCategories", sender: nil)
        
        
    }

    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "showCategories" {
//
//            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//            let destVC = mainStoryboard.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
//
//            destVC.allLocations = self.allLocations
//        }
//    }
    
    @objc func showSortBySeasons() {
        
        performSegue(withIdentifier: "showSortBySeasons", sender: nil)
    }
    
    @objc func showSettings() {
        
        performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    
    //MARK: - Location manager delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //let location = locations.last
        
        let centerOfLatviaLat = 56.998656
        let centerOfLatviaLong = 24.527813

        let camera = GMSCameraPosition.camera(withLatitude: centerOfLatviaLat, longitude: centerOfLatviaLong, zoom: 6.3)
        mapView.animate(to: camera)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
         
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        destVC.locationName = marker.title!
        destVC.locationInfo = marker.snippet!
        
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    // MARK: - Adding a Style to map
    
    func addStyleToMap(){
        
        do {
            
            if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json"){
                
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find MapStyle.json")
            }
        } catch {
            print("One or more of the map styles failed to laod. \(error)")
        }
    }
    
    func myLocationButton(locations: [CLLocation]) {
        
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: centerOfLatviaLat, longitude: centerOfLatviaLong, zoom: 6.3)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.settings.myLocationButton = true
    }
    
    // MARK: - Side Menu bar functions and actions

    @IBAction func openMenuView(_ sender: UIBarButtonItem) {
        
        NotificationCenter.default.post(name: Notification.Name("ToggleSideMenu"), object: nil)
    }
    
}

