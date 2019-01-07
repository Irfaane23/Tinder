//
//  UpdateVC.swift
//  Tinder_Clone
//
//  Created by Irfaane Ousseny on 06/01/2019.
//  Copyright © 2019 Irfaane. All rights reserved.
//

import UIKit
import Parse

class UpdateVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var profileIV: UIImageView!
    
    //switch based on user gender
    @IBOutlet weak var userGenderSwitch: UISwitch!
    @IBOutlet weak var interestedGenderSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.isHidden = true
        
        if let userIsFemale = PFUser.current()?["isFemale"] as? Bool {
            userGenderSwitch.setOn(userIsFemale, animated: false)
        }
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWoman"] as? Bool {
            interestedGenderSwitch.setOn(isInterestedInWomen, animated: false)
        }
        
        // Retrieve user picture
        if let photo = PFUser.current()?["photo"] as? PFFileObject {
            photo.getDataInBackground { (data, _) in
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        self.profileIV.image = image
                    }
                }
            }
        }
        //generateWoman() // should be called only one time
    }
    
    func generateWoman() {
        let imageUrls = [
            "https://upload.wikimedia.org/wikipedia/en/7/76/Edna_Krabappel.png",
            "https://static.comicvine.com/uploads/scale_small/0/40/235856-101359-ruth-powers.png",
            "http://vignette3.wikia.nocookie.net/simpsons/images/f/fb/Serious-sam--cover.jpg/revision/latest?cb=20131109214146",
            "https://s-media-cache-ak0.pinimg.com/736x/e4/42/5a/e4425aad73f01d36ace4c86c3156dcdc.jpg",
            "http://www.simpsoncrazy.com/content/pictures/onetimers/LurleenLumpkin.gif",
            "https://vignette2.wikia.nocookie.net/simpsons/images/b/bc/Becky.gif/revision/latest?cb=20071213001352",
            "http://vignette3.wikia.nocookie.net/simpsons/images/b/b0/Woman_resembling_Homer.png/revision/latest?cb=20141026204206"
        ]
        
        var i : Int = 0
        for image in imageUrls {
            i += 1
            if let url = URL(string: image) {
                if let data = try? Data(contentsOf: url) {
                    let imageFileObject = PFFileObject(name: "picture.png", data: data)
                    
                    // create user based on the image object
                    let user = PFUser()
                    user["photo"] = imageFileObject
                    user.username = String(i)
                    user.password = "azerty23"
                    user["isFemale"] = true
                    user["isInterestedInWoman"] = false
                    
                    // DEBUG
//                    user.signUpInBackground { (success, _) in
//                        if success {
//                            print("New woman user created")
//                        }
//                    }
                }
            }
        }
    }
    
    @IBAction func updateProfileImage(_ sender: Any) {
        // set a pop-up alert to inform the user that he has the choice
        // 1. take picture (doesn't work on the simulator)
        // 2. choose a picture from his phone's library
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            self.presentPhotoPicker(from: .photoLibrary)
            return
        }
        
        let photoAlert = UIAlertController()
        let takePicture = UIAlertAction(title: "Take Picture", style: .default) { _ in
            self.presentPhotoPicker(from: .camera)
        }
        
        let choosePicture = UIAlertAction(title: "Choose Picture", style: .default) { _ in
            self.presentPhotoPicker(from: .photoLibrary)
        }
        photoAlert.addAction(takePicture)
        photoAlert.addAction(choosePicture)
        photoAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // show the pop-up animation
        present(photoAlert,animated: true, completion: nil)
        
    }

    //MARK: - ImagePicker View Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileIV.image = pickerImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func presentPhotoPicker(from sourceType : UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true)
    }
    
    @IBAction func updateInfoTapped(_ sender: Any) {
        // Gender switch Handler
        PFUser.current()?["isFemale"] = userGenderSwitch.isOn
        PFUser.current()?["isInterestedInWoman"] = interestedGenderSwitch.isOn
        
        if let image = profileIV.image {
            if let imageData = image.pngData() {
                PFUser.current()?["photo"] = PFFileObject(name: "profilePicture.png", data: imageData)
                PFUser.current()?.saveInBackground(block: { (_, error) in
                    if error != nil {
                        LogInVC().printError(error: error, message: "Update Failed - Please try again !!")
                    }
                    else {
                        // DEBUG
                        print("Update has been made successfully")
                        self.performSegue(withIdentifier: "updateToSwipeSegue", sender: nil)
                    }
                })
            }
        }
    }
    
    

}
