//
//  My_Bookself_ApplicationApp.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/17/22.
//

import SwiftUI

@main
struct My_Bookself_ApplicationApp: App {
    
    @StateObject var the_visited_cache_store = Store_of_The_Visited_Cached(the_visited_cached: [])
    
    //MARK: The following is for debugging. Do not remove until all testings are done.
    /// The purpose is to test it on the Simulator or the real iOS devices.
//        @StateObject var the_visited_cache_store = preview_of_the_visited_cache_store
    
    var body: some Scene {
        WindowGroup {
            ContentView(the_visited_cache_store: the_visited_cache_store)
        }
    }
}
