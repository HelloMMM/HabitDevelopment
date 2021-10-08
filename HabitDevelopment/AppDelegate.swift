//
//  AppDelegate.swift
//  HabitDevelopment
//
//  Created by HellöM on 2020/6/8.
//  Copyright © 2020 HellöM. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications

var isRemoveAD: Bool = false
var isNotification: Bool = true
var appStyle = 0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let notificationHandler = NotificationHandler()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let style = UserDefaults.standard.object(forKey: "appStyle") {
            
            appStyle = style as! Int
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        IQKeyboardManager.shared.enable = true
        
        if let removeAD = UserDefaults.standard.object(forKey: "isRemoveAD") {
            
            isRemoveAD = removeAD as! Bool
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: { (granted, error) in
            if granted {
                print("允許")
            } else {
                print("不允許")
                isNotification = false
            }
        })
        
        UNUserNotificationCenter.current().delegate = notificationHandler
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in

            for request in requests {
                
//                let nowTime = Date().timeIntervalSince1970
//                let localTrigger = request.content
//                let localTimeInterval = localTrigger.timeInterval
//                let limitDescriptionTime = (-1 * Int(round(nowTime - localTimeInterval)))
//                
//                let duration: TimeInterval = TimeInterval(limitDescriptionTime)
//                
//                let formatter = DateComponentsFormatter()
//                formatter.unitsStyle = .positional
//                formatter.allowedUnits = [ .minute, .second ]
//                formatter.zeroFormattingBehavior = [ .pad ]
//
//                let formattedDuration = formatter.string(from: duration) ?? ""
//                
//                print("formattedDuration: \(formattedDuration)")
            }
        }
        
//        registerNotificationCategory()
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    private func registerNotificationCategory() {
        let newsCategory: UNNotificationCategory = {
            //创建输入文本的action
            let inputAction = UNTextInputNotificationAction(
                identifier: "A",
                title: "A",
                options: [.foreground],
                textInputButtonTitle: "AA",
                textInputPlaceholder: "AAA")
             
            //创建普通的按钮action
            let likeAction = UNNotificationAction(
                identifier: "B",
                title: "B",
                options: [.foreground])
             
            //创建普通的按钮action
            let cancelAction = UNNotificationAction(
                identifier: "C",
                title: "C",
                options: [.destructive])
             
            //创建category
            return UNNotificationCategory(identifier: "D",
                                          actions: [inputAction, likeAction, cancelAction],
                                          intentIdentifiers: [], options: [.customDismissAction])
        }()
         
        //把category添加到通知中心
        UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
    }
}

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])

    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let categoryIdentifier = response.actionIdentifier
        
        print(categoryIdentifier)
        
        completionHandler()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
