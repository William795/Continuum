//
//  AppDelegate.swift
//  Continuum
//
//  Created by William Moody on 6/4/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        checkAccountStatus { (success) in
            let fetchedUserStatement = success ? "Successfully retrieved a logged in user" : "Failed to retrieve a logged in user"
            print(fetchedUserStatement)
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if let error = error {
                print("🚒🚒🚒🚒🚒\(error.localizedDescription) \(error) in function: \(#function)🚒🚒🚒🚒🚒")
                return
            }
            success ? print("Successfully authorized to send push notfiication") : print("DENIED, Can't send this person notificiation")
        }
        application.registerForRemoteNotifications()
        return true
    }
    
    func checkAccountStatus(completion: @escaping (Bool) -> ()) {
        CKContainer.default().accountStatus { (status, error) in
            if let error = error {
                print("error check account status 🚒🚒🚒🚒🚒\(error.localizedDescription) \(error) in function: \(#function)🚒🚒🚒🚒🚒")
                completion(false)
                return
            }else {
                DispatchQueue.main.async {
                    let tabBarController = self.window?.rootViewController
                    let errorText = "Sign into iCloud in Settings"
                    switch status {
                    case .available:
                        completion(true)
                    case .noAccount:
                        tabBarController?.presentSimpleAlertWith(title: errorText, message: "No Account Found")
                        completion(false)
                    case .couldNotDetermine:
                        tabBarController?.presentSimpleAlertWith(title: errorText, message: "There was an unknown error fetching your iCloud Account")
                        completion(false)
                    case .restricted:
                        tabBarController?.presentSimpleAlertWith(title: errorText, message: "Your iCloud account is restricted")
                        completion(false)
                    @unknown default:
                        fatalError()
                    }
                }
            }
        }
    }
}

