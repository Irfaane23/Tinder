//
//  AppDelegate.swift
//  Tinder_Clone
//
//  Created by Irfaane Ousseny on 13/10/2018.
//  Copyright © 2018 Irfaane. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let parseConfig = ParseClientConfiguration {
            $0.applicationId = "XXXX"
            $0.clientKey = "YYYY"
            $0.server = "http://ZZZZZZZ.herokuapp.com/parse"
        }
        Parse.initialize(with: parseConfig)
        
        return true
    }



}

