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
    @Published var image_string: String
    @Published var thumbnail: Image? /// 100 x 117, while the actual image size is 300x350
    
    
    init(title: String, isbn13: String, image_string: String, thumbnail: Image?) {
        self.title = title; self.isbn13 = isbn13; self.image_string = image_string; self.thumbnail = thumbnail
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


//TODO: incomplete. This is an experimental feature.
@ViewBuilder func prepare__preview_of_the_visited_cache_store(url_list: [String]) -> some View {
    /// WARNING: `url_list.count` Non-constant range: argument must be an integer literal
    ForEach(0..<url_list.count) { i in
        /// For example, AsyncImage(url: URL(string: "https://itbook.store/img/books/9781484206485.png"), scale: 1.0/3.0)
        AsyncImage(url: URL(string: url_list[i]), scale: TheControlPanel.thumbnail_scale) { phase in
            if case .success(let image) = phase {
                image.resizable().onAppear {
                    preview_of_the_visited_cache_store.the_visited_cached[i].thumbnail = image
                }
            }
        }
    }
}

let preview_of_the_visited_cache_store = Store_of_The_Visited_Cached(the_visited_cached: [
    TheVisitedCached(title: "Practical MongoDB", isbn13: "9781484206485", image_string: "https://itbook.store/img/books/9781484206485.png", thumbnail: Image("9781484206485 thumbnail")),
    TheVisitedCached(title: "The Definitive Guide to MongoDB, 3rd Edition", isbn13: "9781484211830", image_string: "https://itbook.store/img/books/9781484211830.png", thumbnail: Image("9781484211830 thumbnail")),
    TheVisitedCached(title: "MongoDB in Action, 2nd Edition", isbn13: "9781617291609", image_string: "https://itbook.store/img/books/9781617291609.png", thumbnail: Image("9781617291609 thumbnail")),
])
