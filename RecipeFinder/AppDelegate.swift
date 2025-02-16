//
//  AppDelegate.swift
//  RecipeFinder
//
//  Created by Sukesh Boggavarapu on 11/26/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Set global button tint color
        UIButton.appearance().tintColor = UIColor.init(hex: "#F4C430")
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(hex: "#020058") // Set the background color of the nav bar

        // Customize title text attributes
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white, // Title text color
            .font: UIFont.boldSystemFont(ofSize: 18) // Optional: Font style
        ]

        // Apply the appearance globally
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        if let tabBar = UITabBar.appearance() as? UITabBar {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(hex: "#020058")
            
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.white // Unselected tab button text color
            ]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.init(hex: "#F4C430") // Selected tab button text color
            ]
            
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.init(hex: "#F4C430") // Selected item color
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white
            
            // Assign the appearance
            tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
            
            return true
        }
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

