//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by Hailah on 26/05/2019.
//  Copyright © 2019 Hailah. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DataController.sharedInstance.load()
        return true
    }

    func saveViewContext(){
        try? DataController.sharedInstance.viewContext.save()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveViewContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveViewContext()
    }
        
}

