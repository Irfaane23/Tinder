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

    @IBOutlet weak var swipeImageView: UIImageView!
    var userID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check the server's connection
//        let testParse = PFObject(className: "TestParseServer")
//        testParse["something"] = "saved"
//        testParse.saveInBackground { (success, _) in
//            print("Object has been saved")
//        }
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(matchWithSomeone))
        swipeImageView.addGestureRecognizer(gesture)

        loadImage()
        
        // Geolocation
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, _) in
            if let actualPoint = geoPoint {
                PFUser.current()?["geolocation"] = actualPoint
                PFUser.current()?.saveInBackground()
            }
        }
        
    }

    @objc func matchWithSomeone(gesture: UIPanGestureRecognizer) {
        let labelPoint = gesture.translation(in: view)

        let centerWidth = view.bounds.width / 2
        let centerHeight = view.bounds.height / 2

        swipeImageView.center = CGPoint(x: centerWidth + labelPoint.x, y: centerHeight + labelPoint.y)


        let offsetXFromCenter = centerWidth - swipeImageView.center.x
        var rotationTransform = CGAffineTransform(rotationAngle: offsetXFromCenter / 100)
        let scale = min(100 / abs(offsetXFromCenter), 1)

        var scaleRotation = rotationTransform.scaledBy(x: scale, y: scale)
        swipeImageView.transform = scaleRotation
        
        var interestedOrNot = "" // rejected and interested fields need to be add in heroku
        
        if gesture.state == .ended {
            if swipeImageView.center.x < (centerWidth - 100) {
                //print("No interested")
                interestedOrNot = "rejected"
            }

            if swipeImageView.center.x > (centerWidth + 100) {
                //print("Interested")
                interestedOrNot = "interested"
            }
            
            if interestedOrNot != "" && userID != "" {
                PFUser.current()?.addUniqueObject(userID, forKey: interestedOrNot)
                PFUser.current()?.saveInBackground(block: { (success, _) in
                    if success {
                        self.loadImage()
                    }
                })
            }

            rotationTransform = CGAffineTransform(rotationAngle: 0)
            scaleRotation = rotationTransform.scaledBy(x: 1, y: 1)
            swipeImageView.transform = scaleRotation
            swipeImageView.center = CGPoint(x: centerWidth, y: centerHeight)
        }

    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        PFUser.logOut()
        performSegue(withIdentifier: "logOutSegue", sender: nil)
    }
    
    private func loadImage() {
        if let query = PFUser.query() {

            // Query the users' gender
            if let isFemale = PFUser.current()?["isFemale"] {
                query.whereKey("isInterestedInWoman", equalTo: isFemale)
            }
            if let isInterestedInWoman = PFUser.current()?["isInterestedInWoman"] {
                query.whereKey("isFemale", equalTo: isInterestedInWoman)
            }

            var ignoredUsers : [String] = []
            if let acceptedUsers = PFUser.current()?["interested"] as? String {
                ignoredUsers.append(acceptedUsers)
            }
            if let rejectedUsers = PFUser.current()?["rejected"] as? String {
                ignoredUsers.append(rejectedUsers)
            }
            query.whereKey("objectID", notContainedIn: ignoredUsers)

            if let geolocationPoint = PFUser.current()?["geolocation"] as? PFGeoPoint {
                query.whereKey("geolocation", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: geolocationPoint.latitude-1 , longitude: geolocationPoint.longitude-1), toNortheast: PFGeoPoint(latitude: geolocationPoint.latitude+1, longitude: geolocationPoint.longitude+1))
            }

            query.limit = 1 // we want one result at a time

            query.findObjectsInBackground { (objects, _) in
                if let users = objects {
                    for user in users {
                        if let currentUser = user as? PFUser {
                            if let imageFileObject = currentUser["photo"] as? PFFileObject {
                                imageFileObject.getDataInBackground(block: { (data, _) in
                                    if let imageData = data {
                                        self.swipeImageView.image = UIImage(data: imageData)
                                        if let objectID = user.objectId {
                                            self.userID = objectID
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }

}

