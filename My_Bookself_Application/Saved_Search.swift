//
//  Saved_Search.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/17/22.
//

import Foundation
import SwiftUI

/// ** Assumption **
///  use `isbn13` as id, because it is unique
class Saved_Search: Identifiable, ObservableObject {
    
    @Published var title: String
    
    /// `isbn13` act as ID
    @Published var id: String
    @Published var thumbnail: Image /// 100 x 117, while the actual image size is 300x350
    
    init(title: String, isbn13: String, thumbnail: Image) {
        self.title = title; self.id = isbn13; self.thumbnail = thumbnail
    }
}


class Store_of_saved_searches: ObservableObject {
    
    @Published var saved_searches : [Saved_Search]
    
    init(saved_searches: [Saved_Search]) {
        self.saved_searches = saved_searches
    }
    
    var was_there_previous_search: Bool {
        saved_searches.isEmpty == false
    }
}


let preview_store = Store_of_saved_searches(saved_searches: [Saved_Search(title: "Practical MongoDB", isbn13: "9781484206485", thumbnail: Image("9781484206485 thumbnail"))])
