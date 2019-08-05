//
//  DetailVC.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 12/04/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit
import Hero


func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

class DetailVC: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var viewForScrollView: UIViewX!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var openingHoursLabel: UILabel!
    @IBOutlet weak var navigationBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationInfoLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var hideViewBtn: UIButton!

    
    var locationName: String = ""
    var locationInfo: String = ""
    var locationImage = UIImage()
    var locationLatitude: Double = 0
    var locationLongitude: Double = 0
    var openingHours: String = ""

    
    var oldContentOffset = CGPoint.zero
    var topConstraint:CGFloat = 0
    
    
    var panGR: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBtn.layer.masksToBounds = true
        navigationBtn.layer.cornerRadius = 10
        navigationBtn.layer.borderColor = UIColor.white.cgColor
        navigationBtn.layer.borderWidth = 2
        
        
        
        //scrollView.setContentOffset(CGPoint(x: 0, y: 70), animated: true)
        
        
        //topConstraint = locationImageView.frame.size.height / 2.2
        //scrollViewTopConstraint.constant = topConstraint
        
        self.hero.isEnabled = true
        
        self.scrollView.delegate = self
        
        self.locationNameLabel.text = locationName
        self.locationNameLabel.hero.id = "\(locationName)_name"
        self.locationNameLabel.hero.modifiers = [.zPosition(4)]
        self.locationInfoLabel.text = locationInfo
        self.locationInfoLabel.hero.modifiers = [.zPosition(4)]
        self.locationImageView.image = locationImage
        self.locationImageView.hero.id = "\(locationImage)_image"
        self.locationImageView.hero.modifiers = [.zPosition(2)]
        
        self.openingHoursLabel.text = "Opening Hours: \n\(openingHours)"

            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: locationInfoLabel.bottomAnchor).isActive = true
       
        
//        panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognizer:)))
//        scrollView.addGestureRecognizer(panGR)
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.updateContentView()
    }
    
//    @objc func handlePan(gestureRecognizer:UIPanGestureRecognizer) {
//        // calculate the progress based on how far the user moved
//        let translation = panGR.translation(in: nil)
//        let progress = translation.y / 2 / view.bounds.height
//
//        switch panGR.state {
//        case .began:
//            // begin the transition as normal
//            dismiss(animated: true, completion: nil)
//        case .changed:
//            Hero.shared.update(progress)
//
//            // update views' position (limited to only vertical scroll)
//            Hero.shared.apply(modifiers: [.position(CGPoint(x:locationImageView.center.x, y:translation.y + locationImageView.center.y))], to: locationImageView)
//            Hero.shared.apply(modifiers: [.position(CGPoint(x:locationNameLabel.center.x, y:translation.y + locationNameLabel.center.y))], to: locationNameLabel)
//            Hero.shared.apply(modifiers: [.position(CGPoint(x:locationInfoLabel.center.x, y:translation.y + locationInfoLabel.center.y))], to: locationInfoLabel)
//        default:
//            // end or cancel the transition based on the progress and user's touch velocity
//            if progress + panGR.velocity(in: nil).y / view.bounds.height > 0.3 {
//                Hero.shared.finish()
//            } else {
//                Hero.shared.cancel()
//            }
//        }
//
//    }
    
    
    @IBAction func backPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func navigateBtnPressed(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: "Navigation", message:"Select prefered navigation app", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let googleMaps = UIAlertAction(title: "Google Maps", style: .default) { action in
            
            if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(Float(self.locationLatitude)),\(Float(self.locationLongitude))&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }
        }
        
        let waze = UIAlertAction(title: "Waze", style: .default) { action in
            
            if let url = URL(string: "waze://?ll=\(Float(self.locationLatitude)),\(Float(self.locationLongitude))&navigate=yes" ) {
                UIApplication.shared.open(url, options: [:])
            }
        }
        
        let appleMaps = UIAlertAction(title: "Apple Maps", style: .default) { action in
            
            if let url = URL(string: "http://maps.apple.com/maps?saddr=&daddr=\(Float(self.locationLatitude)),\(Float(self.locationLongitude))" ) {
                UIApplication.shared.open(url, options: [:])
            }
        }
        
        actionSheet.addAction(cancel)
        actionSheet.addAction(googleMaps)
        actionSheet.addAction(appleMaps)
        actionSheet.addAction(waze)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
}

extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}

