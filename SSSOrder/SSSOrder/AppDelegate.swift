//
//  AppDelegate.swift
//  SSSOrder
//
//  Created by Toan Ho on 6/23/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit
import GoogleMaps
import UserNotifications
import ReachabilitySwift
import Whisper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var netWorkStatus: Bool = true
    var reachability: Reachability!
    var reachability2: Reachability!
    var locationManager: CLLocationManager!
    var currentLocation: (lat: String, long: String)?
    var deviceTokenString: String = ""

    private let googleAPIKey = "AIzaSyBbq5fIYk6YDVJEY1BCQgoIQ-cIzhjyLg8"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Set Google SDK
        GMSServices.provideAPIKey(googleAPIKey)

        // Configure location
        registerForLocationUpdateBackground()

        // Confgiure notification
        setPushNotification(application: application)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This
        // can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when 
        // the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application
        // state information to restore your application to its current state in case it is terminated later.
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

    /// check internet status
    func detectInternetConnection() {

    }

    // MARK: Register update location
    func registerForLocationUpdateBackground() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self

        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    // MARK: Register push notification
    func setPushNotification(application: UIApplication) {
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
                if !granted {
                    print("Something went wrong")
                } else {
                    print("Error: \(error?.localizedDescription)")
                }
            }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
//            // iOS 8 support
//        else if #available(iOS 8, *) {
//            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
//            UIApplication.shared.registerForRemoteNotifications()
//        }
    }

    func createNotificatonBanner(title: String, content: String) {
        var announcement = Announcement(title: title, subtitle: content, image: ImageConstant.AppLogo)
        announcement.duration = 3.0
        if self.window?.rootViewController != nil {
            ColorList.Shout.background = UIColor.darkGray
            ColorList.Shout.title = .white
            ColorList.Shout.subtitle = .white
            Whisper.show(shout: announcement, to: topViewController()!)
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})

        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        self.deviceTokenString = deviceTokenString

        // Persist it in your backend in case it's new
        UserDefaultUtils.storeDeviceToken(deviceToken: self.deviceTokenString)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(userInfo)")
        let aps =  (userInfo["aps"] as? [String:Any])
        let notification = aps!["alert"] as? [String:Any]
        let title = notification!["title"] as? String
        let content = notification!["body"] as? String

        createNotificatonBanner(title: title!, content: content!)
    }

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        notification.applicationIconBadgeNumber = 0
    }

    func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

// MARK: - CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let userLocation: CLLocation = locations[0]
        let long = userLocation.coordinate.longitude
        let lat = userLocation.coordinate.latitude
        self.currentLocation = (lat: "\(lat)", long: "\(long)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startUpdatingLocation()
        }
    }
}

// MARK: - Notification delegate
extension AppDelegate: UNUserNotificationCenterDelegate {

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification: ")
//        createNotificatonBanner(title: notification., content: )
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Response: ")
    }
}
