//
//  AppDelegate.swift
//  MetaWeather
//
//  Created by Thomas Rademaker on 7/12/18.
//  Copyright © 2018 Thomas J. Rademaker. All rights reserved.
//

import UIKit
import CoreData
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack(modelName: "MetaWeather")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        NetworkActivityIndicatorManager.shared.isEnabled = true // show network activity indicator in the status bar when an Alamofire network request is in progress
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let weatherViewController = WeatherViewController()
        weatherViewController.managedContext = coreDataStack.managedContext
        let navigationController = UINavigationController(rootViewController: weatherViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
}
