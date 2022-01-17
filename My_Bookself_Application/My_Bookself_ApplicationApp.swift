//
//  My_Bookself_ApplicationApp.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/17/22.
//

import SwiftUI

@main
struct My_Bookself_ApplicationApp: App {
    
    @StateObject var saved_searches = Store_of_saved_searches(saved_searches: [])
    
    /// The following is for debugging.
//        @StateObject var saved_searches = preview_store
    
    var body: some Scene {
        WindowGroup {
            ContentView(the_store: saved_searches)
        }
    }
}
