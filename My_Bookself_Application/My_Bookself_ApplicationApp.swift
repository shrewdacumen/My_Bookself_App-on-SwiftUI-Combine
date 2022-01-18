//
//  My_Bookself_ApplicationApp.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/17/22.
//

import SwiftUI

@main
struct My_Bookself_ApplicationApp: App {
    
    @StateObject var saved_searches = Store_of_The_Visited_Cached(the_visited_cached: [])
    
    //MARK: The following is for debugging. Do not remove until all testings are done.
//        @StateObject var saved_searches = preview_store
    
    var body: some Scene {
        WindowGroup {
            ContentView(the_visited_cache_store: saved_searches)
        }
    }
}
