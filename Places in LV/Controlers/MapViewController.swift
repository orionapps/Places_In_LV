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
import FirebaseStorage

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, GMUClusterManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    
    // Constants
    var locationManager = CLLocationManager()
    var allLocations = [CategoryList]()
    var customInfoWindow : ObjectPreviewView?
    
    let centerOfLatviaLat = 56.998656
    let centerOfLatviaLong = 24.527813
    let isClustering: Bool = true
    let isCustom: Bool = true
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStyleToMap()
        listenToNotifications()
        clusterMarkers()
        loadMarkers()
    }
    
    // MARK: - Side menu methods and segues
    
    @IBAction func openMenuView(_ sender: UIBarButtonItem) {
        
        NotificationCenter.default.post(name: Notification.Name("ToggleSideMenu"), object: nil)
    }
    
    
    func listenToNotifications() {
        
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
    
    
    // MARK: - Loading Markers
    
    func loadMarkers() {
        
        self.customInfoWindow = ObjectPreviewView().loadView()
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        // Fetching data from JSON
        guard let urlPath = Bundle.main.url(forResource: "Data", withExtension: "json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: urlPath)
            self.allLocations = try JSONDecoder().decode(Array<CategoryList>.self, from: data)
            
            self.mapView.clear()
            
            if isClustering {
                
                for location in self.allLocations {
                    
                    let lat = location.lat
                    let long = location.long
                    let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let marker = GMSMarker(position: position)
                    marker.appearAnimation = .pop
                    marker.userData = location
                    
                    if location.locationID == 0 {
                        
                        marker.icon = UIImage(named: "sightseeingMarker")
                    } else if location.locationID == 1 {
                        
                        marker.icon = UIImage(named: "museumMarker")
                    } else if location.locationID == 2 {
                        
                        marker.icon = UIImage(named: "parksMarker")
                    } else if location.locationID == 3 {
                        
                        marker.icon = UIImage(named: "kidsMarker")
                    } else {
                        
                        marker.icon = UIImage(named: "sportsMarker")
                    }
                    
                    // Adding objects and info to cluster
                    let item = POIItem(position: position, name: location.locationName, marker: marker, image: location.placePhoto!, locationInfo: location.locationInfo, lat: location.lat, long: location.long, openingHours: location.openingHours!)
                    
                    clusterManager.add(item)
                }
            } else {
            }
        } catch {
            print(error)
        }
    }
    
    
    //MARK: - Location manager delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let camera = GMSCameraPosition.camera(withLatitude: centerOfLatviaLat, longitude: centerOfLatviaLong, zoom: 6)
        mapView.animate(to: camera)
        
        mapView.settings.myLocationButton = true
        self.locationManager.stopUpdatingLocation()
    }

    
    // MARK: - Google maps delegate
    
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
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Detail", bundle: nil)
        let destVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        destVC.locationName = (marker.userData as! POIItem).name
        destVC.locationInfo = (marker.userData as! POIItem).locationInfo
        destVC.locationLatitude = (marker.userData as! POIItem).lat
        destVC.locationLongitude = (marker.userData as! POIItem).long
        destVC.openingHours = (marker.userData as! POIItem).openingHours
        
        Helper().startActivityIndicator(view: mapView, activityIndicator: activityIndicator)
        
        if Reachability.isConnectedToNetwork() {
            
            let storageRef = Storage.storage().reference(withPath: "Objects/\((marker.userData as! POIItem).image).jpg")
            storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
                if let error = error {
                    print("Got an error fetching data: \(error.localizedDescription)")
                    return
                }

                if let data = data {

                    destVC.locationImage = UIImage(data: data)!
                    Helper().stopActivityIndicator(activityIndicator: self!.activityIndicator)
                    
                    self!.navigationController?.pushViewController(destVC, animated: true)
                }
            }
                    
        } else {
            
            Helper().stopActivityIndicator(activityIndicator: activityIndicator)
            
            let alert = UIAlertController(title: "Faild to load info", message: "Please check your internet connection and try again", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            }
}
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        if let poiItem = marker.userData as? POIItem {


            marker.tracksInfoWindowChanges = true
            
            self.customInfoWindow?.contentView.layer.cornerRadius = 15
            self.customInfoWindow?.objectLabel.sizeToFit()
            self.customInfoWindow?.objectLabel.adjustsFontSizeToFitWidth = true
            self.customInfoWindow?.objectLabel.textAlignment = NSTextAlignment.center

            self.customInfoWindow?.objectLabel.text = poiItem.name


            //self.customInfoWindow?.imageView.image = UIImage(contentsOfFile: <#T##String#>)
//            if let path = Bundle.main.path(forResource: poiItem.image, ofType: "jpg"){
            
//
//                self.customInfoWindow?.imageView.image = UIImage(contentsOfFile: path)!
//            }
            return self.customInfoWindow
        }else {
            UIView.animate(withDuration: 0.5, delay: 0.2, options: [.curveEaseOut],
                           animations: {
                            let newCamera = GMSCameraPosition.camera(withTarget: marker.position,
                                                                     zoom: self.mapView.camera.zoom + 1)
                            let update = GMSCameraUpdate.setCamera(newCamera)
                            self.mapView.animate(with: update)
            }, completion: {
                finished in
            })
            return nil
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let poiItem = marker.userData as? POIItem {
            
            NSLog("Did tap marker for cluster item \(poiItem.name)")
            guard let customMarkerView = marker.userData as? ObjectPreviewView else { return false }
            customMarkerView.contentView.layer.cornerRadius = 15
            customMarkerView.previewLabelName = poiItem.name
            
            
//            if let path = Bundle.main.path(forResource: poiItem.image, ofType: "jpg"){
//
//                customMarkerView.imageView.image = UIImage(contentsOfFile: path)!
//            }
        } else {
            
            UIView.animate(withDuration: 0.5, delay: 0.2, options: [.curveEaseOut],
                           animations: {
                            let newCamera = GMSCameraPosition.camera(withTarget: marker.position,
                                                                     zoom: self.mapView.camera.zoom + 1)
                            let update = GMSCameraUpdate.setCamera(newCamera)
                            self.mapView.animate(with: update)
            }, completion: {
                finished in
            })
            NSLog("Did tap a normal marker")
        }
        return false
    }
    
       
    // MARK: - Marker Clusetring methods

    func clusterMarkers() {
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        clusterManager.setDelegate(self, mapDelegate: self)
        
        renderer.minimumClusterSize = 5
    }
}


