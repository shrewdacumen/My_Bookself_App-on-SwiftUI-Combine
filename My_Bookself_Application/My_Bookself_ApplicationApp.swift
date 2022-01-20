//
//  My_Bookself_ApplicationApp.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/17/22.
//

import SwiftUI

@main
struct My_Bookself_ApplicationApp: App {
    
    /// The control of the initial data of `the_visited_cache_store` is dependent on TDD (test-driven development) setting that
    ///  is declared in `struct TheControlPanel`.  Please see it for more information.
    @StateObject var the_visited_cache_store = TheControlPanel.TDD_SETTING != .TEST_BookView ? Store_of_The_Visited_Cached(the_visited_cached: []):preview_of_the_visited_cache_store
    @StateObject var user_note = UserNote()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(the_visited_cache_store: the_visited_cache_store)
                .environmentObject(user_note)
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
