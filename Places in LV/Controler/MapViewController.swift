//
//  MapViewController.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 02/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthSideMenuConstraint: NSLayoutConstraint!
    
    let screenSize:CGRect = UIScreen.main.bounds
    var sideMenuWidth: CGFloat = 0
    var menuShowing = false
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        setUpSideMenuWidth()
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
        
        if (menuShowing) {
            self.leadingConstraint.constant = -sideMenuWidth
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            self.leadingConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                })
        }
        
        menuShowing = !menuShowing
    }
    
    func setUpSideMenuWidth() {
        
        self.mapView.bringSubviewToFront(self.sideMenuView)
        
        sideMenuWidth = screenSize.width * 0.4
        self.widthSideMenuConstraint.constant = sideMenuWidth
        self.leadingConstraint.constant = -sideMenuWidth
        self.sideMenuView.layoutIfNeeded()
    }
    
}

