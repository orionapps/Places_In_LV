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


    

    @IBOutlet weak var btnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationInfoLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var hideViewBtn: UIButton!
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    
    var locationName: String = ""
    var locationInfo: String = ""
    var locationImage = UIImage()
    
    
    var oldContentOffset = CGPoint.zero
    var topConstraint:CGFloat = 0

    
    var panGR: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scrollView.setContentOffset(CGPoint(x: 0, y: 70), animated: true)
        
        
        topConstraint = locationImageView.frame.size.height / 2.2
        scrollViewTopConstraint.constant = topConstraint
        
        self.hero.isEnabled = true
        
        self.scrollView.delegate = self
    
       self.locationNameLabel.text = locationName
       self.locationNameLabel.hero.id = "\(locationName)_name"
        print("\(locationName)_name")
        self.locationNameLabel.hero.modifiers = [.zPosition(4)]
       self.locationInfoLabel.text = locationInfo
        self.locationInfoLabel.hero.modifiers = [.zPosition(4)]
       self.locationImageView.image = locationImage
       self.locationImageView.hero.id = "\(locationImage)_image"
        print("\(locationImage)_image")
        self.locationImageView.hero.modifiers = [.zPosition(2)]

        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: locationInfoLabel.bottomAnchor).isActive = true
        
        panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognizer:)))
        view.addGestureRecognizer(panGR)
    }
    
    @objc func handlePan(gestureRecognizer:UIPanGestureRecognizer) {
        // calculate the progress based on how far the user moved
        let translation = panGR.translation(in: nil)
        let progress = translation.y / 2 / view.bounds.height
        
        switch panGR.state {
        case .began:
            // begin the transition as normal
            dismiss(animated: true, completion: nil)
        case .changed:
            Hero.shared.update(progress)
            
            // update views' position (limited to only vertical scroll)
            Hero.shared.apply(modifiers: [.position(CGPoint(x:locationImageView.center.x, y:translation.y + locationImageView.center.y))], to: locationImageView)
            Hero.shared.apply(modifiers: [.position(CGPoint(x:locationNameLabel.center.x, y:translation.y + locationNameLabel.center.y))], to: locationNameLabel)
            Hero.shared.apply(modifiers: [.position(CGPoint(x:locationInfoLabel.center.x, y:translation.y + locationInfoLabel.center.y))], to: locationInfoLabel)
        default:
            // end or cancel the transition based on the progress and user's touch velocity
            if progress + panGR.velocity(in: nil).y / view.bounds.height > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }

}
    

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let delta =  scrollView.contentOffset.y - oldContentOffset.y

        //we compress the top view
        if delta > 0 && scrollViewTopConstraint.constant > 70 && scrollView.contentOffset.y > 0 {
            scrollViewTopConstraint.constant -= delta
            scrollView.contentOffset.y -= delta

        }

        //we expand the top view
        if delta < 0 && scrollViewTopConstraint.constant < topConstraint && scrollView.contentOffset.y < 0{
            scrollViewTopConstraint.constant -= delta
            scrollView.contentOffset.y -= delta

        }
        oldContentOffset = scrollView.contentOffset
    }

    
}

