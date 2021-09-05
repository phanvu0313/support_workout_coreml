/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Delegate class for the application.
*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 0.5)
            // Override point for customization after application launch.
            return true
        }
}
