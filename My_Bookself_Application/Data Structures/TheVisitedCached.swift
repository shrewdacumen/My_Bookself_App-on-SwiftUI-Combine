//
//  TheVisitedCached.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/17/22.
//

import Foundation
import SwiftUI

/// ** Assumption **
///  use `isbn13` as id, because it is unique
class TheVisitedCached: Identifiable, ObservableObject {
    var id = UUID()
    
    @Published var title: String
    @Published var isbn13: String
    @Published var thumbnail: Image /// 100 x 117, while the actual image size is 300x350
    
    init(title: String, isbn13: String, thumbnail: Image) {
        self.title = title; self.isbn13 = isbn13; self.thumbnail = thumbnail
    }
}


class Store_of_The_Visited_Cached: ObservableObject {
    
    @Published var the_visited_cached : [TheVisitedCached]
    
    init(the_visited_cached: [TheVisitedCached]) {
        self.the_visited_cached = the_visited_cached
    }
    
    var was_there_previous_search: Bool {
        the_visited_cached.isEmpty == false
    }
}


let preview_store = Store_of_The_Visited_Cached(the_visited_cached: [TheVisitedCached(title: "Practical MongoDB", isbn13: "9781484206485", thumbnail: Image("9781484206485 thumbnail"))])
