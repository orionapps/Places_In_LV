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
    var allLocations = [CategoryList]()
    var customInfoWindow : ObjectPreviewView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customInfoWindow = ObjectPreviewView().loadView()
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
        guard let urlPath = Bundle.main.url(forResource: "Data", withExtension: "json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: urlPath)
            self.allLocations = try JSONDecoder().decode(Array<CategoryList>.self, from: data)
            
            for location in self.allLocations {
                
                let lat = location.lat
                let long = location.long
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                marker.title = location.locationName
                marker.appearAnimation = .pop

                marker.userData = location
                
                if location.locationID == 0 {
                    
                    marker.icon = GMSMarker.markerImage(with: .blue)
                } else if location.locationID == 1 {
                    
                    marker.icon = GMSMarker.markerImage(with: .red)
                } else if location.locationID == 2 {
                    
                    marker.icon = GMSMarker.markerImage(with: .green)
                } else if location.locationID == 3 {
                    
                    marker.icon = GMSMarker.markerImage(with: .black)
                } else {
                    
                    marker.icon = GMSMarker.markerImage(with: .yellow)
                }
                
                marker.map = mapView
            }
            
            
            
//            for location in allLocations.Sightseeings!{
//
//                let lat = location.lat
//                let long = location.long
//
//                let marker = GMSMarker()
//                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
//                marker.title = location.locationName
//                marker.userData = location
//
////                if let path = Bundle.main.path(forResource: location.placePhoto, ofType: "jpg"){
////
////                    marker.icon = UIImage(contentsOfFile: path)!.withRenderingMode(.alwaysTemplate)
////                }
//
//                marker.icon = GMSMarker.markerImage(with: .red)
//                //marker.snippet = location.locationInfo
//                marker.map = mapView
//
//            }
//
//            for location in allLocations.Museums! {
//
//                let lat = location.lat
//                let long = location.long
//
//                let marker = GMSMarker()
//                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
//                marker.title = location.locationName
//                marker.userData = location
//
////                if let path = Bundle.main.path(forResource: location.placePhoto, ofType: "jpg"){
////
////                    marker.icon = UIImage(contentsOfFile: path)!.withRenderingMode(.alwaysTemplate)
////                }
//                 marker.icon = GMSMarker.markerImage(with: .blue)
////
//                //marker.snippet = location.locationInfo
//                marker.map = mapView
//            }
//
//            for location in allLocations.NatureAndParks!{
//
//                let lat = location.lat
//                let long = location.long
//
//                let marker = GMSMarker()
//                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
//                marker.title = location.locationName
//                marker.userData = location
//
//
////                if let path = Bundle.main.path(forResource: location.placePhoto, ofType: "jpg"){
////
////                    marker.icon = UIImage(contentsOfFile: path)!.withRenderingMode(.alwaysTemplate)
////                }
//                 marker.icon = GMSMarker.markerImage(with: .white)
//                //marker.snippet = location.locationInfo
//                marker.map = mapView
//            }
//
//            for location in allLocations.Playgrounds!{
//
//                let lat = location.lat
//                let long = location.long
//
//                let marker = GMSMarker()
//                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
//                marker.title = location.locationName
//                marker.userData = location
//
////                if let path = Bundle.main.path(forResource: location.placePhoto, ofType: "jpg"){
////
////                    marker.icon = UIImage(contentsOfFile: path)!.withRenderingMode(.alwaysTemplate)
////                }
//
//                 marker.icon = GMSMarker.markerImage(with: .green)
//                //marker.snippet = location.locationInfo
//                marker.map = mapView
//            }
//
//            for location in allLocations.sportsPlaygrounds!{
//
//                let lat = location.lat
//                let long = location.long
//
//                let marker = GMSMarker()
//                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
//                marker.title = location.locationName
//                marker.userData = location
//
////                if let path = Bundle.main.path(forResource: location.placePhoto, ofType: "jpg"){
////
////                    marker.icon = UIImage(contentsOfFile: path)!.withRenderingMode(.alwaysTemplate)
////                }
//                 marker.icon = GMSMarker.markerImage(with: .black)
//                //marker.snippet = location.locationInfo
//                marker.map = mapView
//            }

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
        
        let centerOfLatviaLat = 56.998656
        let centerOfLatviaLong = 24.527813

        let camera = GMSCameraPosition.camera(withLatitude: centerOfLatviaLat, longitude: centerOfLatviaLong, zoom: 6.3)
        mapView.animate(to: camera)
        
        mapView.settings.myLocationButton = true
        
        self.locationManager.stopUpdatingLocation()
    }
    

    
    // MARK: - Google maps delegate
    
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//
//        guard let customMarkerView = marker.iconView as? ObjectPreviewView else
//
//        return false
//    }
    
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
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        destVC.locationName = (marker.userData as! CategoryList).locationName
        
        if let path = Bundle.main.path(forResource: (marker.userData as! CategoryList).placePhoto, ofType: "jpg"){
            
            destVC.locationImage = UIImage(contentsOfFile: path)!
        }

        
        self.present(destVC, animated: true, completion: nil)
    }
    

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {


        self.customInfoWindow?.objectLabel.text = (marker.userData as! CategoryList).locationName
        
        if let path = Bundle.main.path(forResource: (marker.userData as! CategoryList).placePhoto, ofType: "jpg"){
            
            self.customInfoWindow?.imageView.image = UIImage(contentsOfFile: path)!
        }

        return self.customInfoWindow
    }

    
    

    
    // MARK: - Side Menu bar functions and actions

    @IBAction func openMenuView(_ sender: UIBarButtonItem) {
        
        NotificationCenter.default.post(name: Notification.Name("ToggleSideMenu"), object: nil)
    }
    
}

//class MapItem:GMSMarker {
//    var model: CategoryList!  //your data model
//    init(data: CategoryList) {
//        super.init()
//        // pass cordinate
//
//        for location in data.Museums!{
//            self.position = CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
//
//        }
//        self.model = data
//    }
//}

