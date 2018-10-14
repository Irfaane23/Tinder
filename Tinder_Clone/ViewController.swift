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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let testParse = PFObject(className: "TestParseServer")
        testParse["something"] = "saved"
        testParse.saveInBackground { (success, _) in
            print("Object has been saved")
        }
        
    }


}

