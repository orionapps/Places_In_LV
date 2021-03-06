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
import FirebaseAuth

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, GMUClusterManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    @IBOutlet weak var alphaView: UIView!
    
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
        
        setUpView()
    }
    
    //MARK: - Setting up view
    
    func setUpView() {
        
        addStyleToMap()
        listenToNotifications()
        clusterMarkers()
        loadMarkers()
        alphaView.isHidden = true
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        swipeLeft.direction = .left
        self.alphaView.addGestureRecognizer(swipeLeft)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.alphaView.addGestureRecognizer(tap)
    }
    
    // MARK: - Side menu methods and segues
    
    @IBAction func openMenuView(_ sender: UIBarButtonItem) {
        
        NotificationCenter.default.post(name: Notification.Name("ToggleSideMenu"), object: nil)
        
        removeAlphaView()
    }
    
    @objc func swipeAction(swipe: UISwipeGestureRecognizer) {
        
        NotificationCenter.default.post(name: Notification.Name("ToggleSideMenu"), object: nil)
        
        removeAlphaView()
    }
    
    @objc func tapAction(tap: UITapGestureRecognizer) {
        
        NotificationCenter.default.post(name: Notification.Name("ToggleSideMenu"), object: nil)
        
        removeAlphaView()
    }
    
    //MARK: - Notifications
    
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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(signOut),
                                               name: NSNotification.Name(rawValue: "signOut"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(removeAlphaView),
                                               name: NSNotification.Name(rawValue: "removeAlphaView"),
                                               object: nil)
    }
    
    //MARK: - Action methods
    
    @objc func showCategories() {
        
        performSegue(withIdentifier: "showCategories", sender: nil)
        removeAlphaView()
    }
    
    
    @objc func showSortBySeasons() {
        
        performSegue(withIdentifier: "showSortBySeasons", sender: nil)
        removeAlphaView()
    }
    
    
    @objc func showSettings() {
        
        performSegue(withIdentifier: "showSettings", sender: nil)
        removeAlphaView()
    }
    
    
    @objc func signOut() {
        
        removeAlphaView()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let authStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let authVC =  authStoryboard.instantiateViewController(withIdentifier: Constants.Storyboard.authVC) as! UINavigationController
        view.window?.rootViewController = authVC
        view.window?.makeKeyAndVisible()
    }
    
    
    @objc func removeAlphaView() {
        
        if UserDefaults.standard.bool(forKey: "sideMenuIsOpen") == true {
            UIView.animate(withDuration: 0.3) {
                self.alphaView.alpha = 0.4
                self.alphaView.isHidden = false
            }
        } else {
            
            UIView.animate(withDuration: 0.3) {
                self.alphaView.alpha = 0
                self.alphaView.isHidden = true
            }
        }
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
                    } else if location.locationID == 4{
                        
                        marker.icon = UIImage(named: "sportsMarker")
                    } else {
                        
                        marker.icon = UIImage(named: "sportsMarker")
                    }
                    
                    // Adding objects and info to cluster
                    let item = POIItem(position: position, name: location.locationName, marker: marker, image: location.placePhoto, locationInfo: location.locationInfo, lat: location.lat, long: location.long, openingHours: location.openingHours, imageArbitration: location.imageArbitration, descriptionArbitration: location.descriptionArbitration)
                    
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
        
        if let openingHoursExists = (marker.userData as! POIItem).openingHours {
            destVC.openingHours = openingHoursExists
        } else {
            destVC.openingHours = "Unknown"
        }
        
        if let imageArbitrationExists = (marker.userData as! POIItem).imageArbitration {
            destVC.imageArbitration = imageArbitrationExists
        } else {
            destVC.imageArbitration = "Explore Latvia team"
        }
        
        if let descriptionArbitrationExists = (marker.userData as! POIItem).descriptionArbitration {
            destVC.descriptionArbitration = descriptionArbitrationExists
        } else {
            destVC.descriptionArbitration = "Explore Latvia team"
        }
        
        Helper().startActivityIndicator(view: mapView, activityIndicator: activityIndicator)
        
        if Reachability.isConnectedToNetwork() {
            
            let storageRef = Storage.storage().reference(withPath: "\(Constants.MyKeys.imageFolderInFirebase)/\((marker.userData as! POIItem).image!).jpg")
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
            
            let alert = UIAlertController(title: Constants.ErrorMessages.internetConnectionErrorTitle.localiz(), message: Constants.ErrorMessages.internetConnectionErrorMessage.localiz(), preferredStyle: UIAlertController.Style.alert)
            
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
            
            return self.customInfoWindow
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
            return nil
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let poiItem = marker.userData as? POIItem {
            
            NSLog("Did tap marker for cluster item \(poiItem.name)")
            guard let customMarkerView = marker.userData as? ObjectPreviewView else { return false }
            customMarkerView.contentView.layer.cornerRadius = 15
            customMarkerView.previewLabelName = poiItem.name
            
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
        }
        return false
    }
    
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        let title = "Add new object at this location"
        let cancelTitle = "Cancel"
        let buttonTitle = "Add new object"
    
        let actionSheet = UIAlertController(title: title.localiz(), message:nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: cancelTitle.localiz(), style: .cancel, handler: nil)
        
        let addNewObject = UIAlertAction(title: buttonTitle.localiz(), style: .default) { action in
            
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "NewObjectAdding", bundle: nil)
            let newObjectVC = mainStoryboard.instantiateViewController(withIdentifier: "NewObjectAddingVC") as! NewObjectAddingVC
            
            newObjectVC.tappedLatitude = String(coordinate.latitude)
            newObjectVC.tappedLongitude = String(coordinate.longitude)
            
            self.navigationController?.pushViewController(newObjectVC, animated: true)
        }
        
        actionSheet.addAction(cancel)
        actionSheet.addAction(addNewObject)
        
        present(actionSheet, animated: true, completion: nil)
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


