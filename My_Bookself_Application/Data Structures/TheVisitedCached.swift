//
//  TheVisitedCached.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/17/22.
//

import Foundation
import SwiftUI


/// ** The Purpose of `TheVisitedCached` **
/// TheVisitedCached supports the view model of `ContentView` which
///  is the first view,
///
/// ** Assumption **
/// - thumbnail: thumbnail shall be nil before it is cached or first access to the remote endpoint.
/// - However, title, isbn13, image_string are all cached as well.
/// - any sorting on this data type will be based only on title.
class TheVisitedCached: Identifiable, Hashable, Equatable, Comparable, ObservableObject {
    var id = UUID()
    
    @Published var title: String
    @Published var isbn13: String
    @Published var image_string: String
    @Published var thumbnail: Image? /// 100 x 117, while the actual image size is 300x350
    
    init(title: String, isbn13: String, image_string: String, thumbnail: Image?) {
        self.title = title; self.isbn13 = isbn13; self.image_string = image_string; self.thumbnail = thumbnail
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(title); hasher.combine(isbn13); hasher.combine(image_string)
    }
    static func == (l: TheVisitedCached, r: TheVisitedCached) -> Bool {
        l.isbn13 == r.isbn13
    }
    static func < (l: TheVisitedCached, r: TheVisitedCached) -> Bool {
        l.title < r.title
    }
}

/// ** The Purpose of `Store_of_The_Visited_Cached` **
/// Store_of_The_Visited_Cached supports the view model of `ContentView` which
///  is the first view,
class Store_of_The_Visited_Cached: ObservableObject {
    /// I turned the_visited_cached from an array into a set,
    /// Because I don't want the duplicates.
    @Published var the_visited_cached : Set<TheVisitedCached>
    
    init(the_visited_cached: Set<TheVisitedCached>) {
        self.the_visited_cached = the_visited_cached
    }
    
    var was_there_previous_search: Bool {
        the_visited_cached.isEmpty == false
    }
}


/// The default data for `ContentView_Previews`
let preview_of_the_visited_cache_store = Store_of_The_Visited_Cached(the_visited_cached: [
    TheVisitedCached(title: "Practical MongoDB", isbn13: "9781484206485", image_string: "https://itbook.store/img/books/9781484206485.png", thumbnail: Image("9781484206485 thumbnail")),
    TheVisitedCached(title: "The Definitive Guide to MongoDB, 3rd Edition", isbn13: "9781484211830", image_string: "https://itbook.store/img/books/9781484211830.png", thumbnail: Image("9781484211830 thumbnail")),
    TheVisitedCached(title: "MongoDB in Action, 2nd Edition", isbn13: "9781617291609", image_string: "https://itbook.store/img/books/9781617291609.png", thumbnail: Image("9781617291609 thumbnail")),
])



/// Please neglect the WARNING from Xcode: because it is purposed for testing an experimental feature.
/// I may remove the follow func if necessary to suppress the warning in the future.
//TODO: incomplete. This is an experimental feature for `ContentView_Previews`
/**
@ViewBuilder func prepare__preview_of_the_visited_cache_store(url_list: [String]) -> some View {
    /// WARNING: `url_list.count` Non-constant range: argument must be an integer literal
    ForEach(0..<url_list.count) { i in
        AsyncImage(url: URL(string: url_list[i])) { image in
            image
                .frame(width: TheControlPanel.ContentView_image_size.width, height: TheControlPanel.ContentView_image_size.height, alignment: .center)
                .onAppear {
                    preview_of_the_visited_cache_store.Array(the_visited_cached)[i].thumbnail = image
                }
        } placeholder: {
            ZStack {
                Text("Loading ...")
                    .foregroundColor(Color.yellow)
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .frame(width: TheControlPanel.ContentView_image_size.width, height: TheControlPanel.ContentView_image_size.height, alignment: .center)
                    .foregroundColor(Color.blue)
            }
        }
    }
}
*/
