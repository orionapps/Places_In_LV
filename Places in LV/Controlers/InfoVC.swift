//
//  InfoVC.swift
//  Places in LV
//
//  Created by Aleksandrs Muravjovs on 31/10/2019.
//  Copyright © 2019 Aleksandrs Muravjovs. All rights reserved.
//

import UIKit

class InfoVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoTextView: UITextView!
    
    var imageInfoText: String = ""
    var descriptionInfoText: String = ""
    var image = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    func setUpView() {
        
        infoTextView.delegate = self
        self.imageView.image = image
        
        if descriptionInfoText == "" {
            self.infoTextView.text = "We would like to say thank you to \(imageInfoText) for the image in this location."
        } else if descriptionInfoText == "" && imageInfoText == ""{
            self.infoTextView.text = "Image and description for this object was made by Explore Latvia team"
        } else {
            self.infoTextView.text = "We would like to say thank you to \(imageInfoText) for the image in this location \nAnd would like to say thank you to \(descriptionInfoText) from where description was taken from/created by."
        }
    }
    
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL.absoluteString == descriptionInfoText) {
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        }
        return false
        }
    }


extension UITextView {
    func hyperLink(originalText: String, hyperLink: String, urlString: String) {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        let fullRange = NSMakeRange(0, attributedOriginalText.length)
        attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: fullRange)
//        self.linkTextAttributes = [
//            NSForegroundColorAttributeName: UIConfig.primaryColour,
//            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,
//        ]
        self.attributedText = attributedOriginalText
    }
}
