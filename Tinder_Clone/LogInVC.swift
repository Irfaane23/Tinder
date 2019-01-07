//
//  LogInVC.swift
//  Tinder_Clone
//
//  Created by Irfaane Ousseny on 06/01/2019.
//  Copyright © 2019 Irfaane. All rights reserved.
//

import UIKit
import Parse

class LogInVC: UIViewController {
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var logInSignUpButton: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var changeLogInSignUpButton: UIButton!
    @IBOutlet weak var userPassword: UITextField!
    
    var signUpEnable : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        errorMessageLabel.isHidden = true
    }
    
   
    @IBAction func logInSignUpTapped(_ sender: Any) {
        
        if signUpEnable { // Create a new user
            let user = PFUser()
            user.username = username.text
            user.password = userPassword.text
            
            user.signUpInBackground { (success, error) in
                if error != nil { // Something wrong happen
                    self.printError(error: error, message: "Sign Up Failed - Please try again !!")
                }
                else { // SignUp successfully
                    // DEBUG
                     print("Sign Up OK")
                    self.performSegue(withIdentifier: "updateSegue", sender: nil)
                }
            }
        }
        else { // user already registered in server and need to logIn
            if let userName = username.text {
                if let password = userPassword.text {
                    PFUser.logInWithUsername(inBackground: userName, password: password) { (user, error) in
                        
                        if error != nil {
                            self.printError(error: error, message: "LogIn Failed - Please try again !!")
                        }
                        else {
                            // DEBUG
                             print("Log In OK")
                            if user?["isFemale"] != nil {
                                self.performSegue(withIdentifier: "logToSwipSegue", sender: nil)
                            }
                            else {
                                self.performSegue(withIdentifier: "updateSegue", sender: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func printError(error : Error?, message : String) {
        var errorMsg = message
        if let newError = error as NSError? {
            if let detailError = newError.userInfo["error"] as? String {
                errorMsg = detailError
            }
        }
        self.errorMessageLabel.isHidden = false
        self.errorMessageLabel.text = errorMsg
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            if PFUser.current()?["isFemale"] != nil {
                self.performSegue(withIdentifier: "logToSwipSegue", sender: nil)
            }
            else {
                self.performSegue(withIdentifier: "updateSegue", sender: nil)
            }
        }
    }
    
    
    @IBAction func updateLogInSignUpTapped(_ sender: Any) {
        if signUpEnable {
            changeLogInSignUpButton.setTitle("Sign UP", for: .normal)
            logInSignUpButton.setTitle("Log In", for: .normal)
            signUpEnable = false
        }
        else {
            changeLogInSignUpButton.setTitle("Log In", for: .normal)
            logInSignUpButton.setTitle("Sign up", for: .normal)
            signUpEnable = true
        }
    }

}
