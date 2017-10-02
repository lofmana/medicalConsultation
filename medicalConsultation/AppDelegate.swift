//
//  AppDelegate.swift
//  medicalConsultation
//
//  Created by Adam Tan on 20/6/17.
//  Copyright © 2017 Adam Tan. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import ApiAI



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

     let currencyCode = "eur"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
       
        
        let configuration: AIConfiguration = AIDefaultConfiguration()
        configuration.clientAccessToken = "6815eecd3760468c8b665b41301873d2"
        let apiai = ApiAI.shared()
        apiai?.configuration = configuration

        return true
    }

    // MARK: Custom Methods for PDF creation
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func getStringValueFormattedAsCurrency(value: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.currencyCode = currencyCode
        numberFormatter.maximumFractionDigits = 2
        
        let formattedValue = numberFormatter.string(from: NumberFormatter().number(from: value)!)
        return formattedValue!
    }
    
    
    func getDocDir() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

