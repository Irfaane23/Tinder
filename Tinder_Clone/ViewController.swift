//
//  ViewController.swift
//  Tinder_Clone
//
//  Created by Irfaane Ousseny on 13/10/2018.
//  Copyright © 2018 Irfaane. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var swipeLabel: UILabel!
    var myMatch : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let testParse = PFObject(className: "TestParseServer")
        testParse["something"] = "saved"
        testParse.saveInBackground { (success, _) in
            print("Object has been saved")
        }
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(swipe))
        swipeLabel.addGestureRecognizer(gesture)
        
    }
    
    @objc func swipe(gesture : UIPanGestureRecognizer) {
        let translation = gesture.translation(in: swipeLabel)
        let transformTranslation = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        let screenWidth = UIScreen.main.bounds.width
        let translationPercent = translation.x / (screenWidth/2)
        let rotationAngle = (CGFloat.pi/6) * translationPercent
    
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        let transform = transformTranslation.concatenating(rotationTransform)
        swipeLabel.transform = transform
        
        if translation.x > 0 {
            swipeLabel.backgroundColor = UIColor.green
            //myMatch = true
        }
        else {
            swipeLabel.backgroundColor = UIColor.red
            //myMatch = false
        }
    }
    
    


}

