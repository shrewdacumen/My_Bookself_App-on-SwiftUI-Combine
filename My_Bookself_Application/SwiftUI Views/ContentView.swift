//
//  ContentView.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/17/22.
//

import SwiftUI

/// This controls the states of user interaction with `the textField`.
enum TheTextFieldMode {
    /// when tapping the textField and it is before the search execution by pressing the enter key.
    case showCached
    /// the mode when the search result is about to see or shown.
    case showSearchResult
}


struct ContentView: View {
    
    @ObservedObject var the_visited_cache_store: Store_of_The_Visited_Cached
    
    @State var search_key: String = ""
    //TODO: incomplete. add the feature accordingly.
    @State var the_total_pages_searched = 0
    
    @State var textField_mode: TheTextFieldMode = .showCached
    
    var body: some View {
        
        NavigationView {
            
            List {
                
                // Mark: - This section that caches the search data
                /// that is stored as `the_visited_cache_store` in this project.
                ///
                /// **NOTE**
                /// `sorted()` was being used as a makeshit to remove an error that
                ///   Generic struct 'ForEach' requires that 'Set<TheVisitedCached>' conform to 'RandomAccessCollection'
                ForEach(the_visited_cache_store.the_visited_cached.sorted(), id: \.self) { the_cached in
                    VStack(alignment: .center, spacing: 5) {
                        Text(the_cached.isbn13)
                            .fontWeight(.light)
                        Text(the_cached.title)
                            .font(.headline)
                        
                        /// When the cached `thumbnail` exists, given that the whole cache exits.
                        if let thumbnail = the_cached.thumbnail {
                            NavigationLink(destination: BookView(isbn13: the_cached.isbn13)) {
                                thumbnail
                            }
                            .onTapGesture {
                                enter_into_the_caching_state()
                                //                                add_the_data_to_the_cache(the_cached)
                            }
                        } else { /// Those cases of both BEFORE thumbnail is cached or when it is being used by ContentView_Previews
                            NavigationLink(destination: BookView(isbn13: the_cached.isbn13)) {
                                AsyncImage(url: URL(string: the_cached.image_string)) { image in
                                    image
                                        .frame(width: TheControlPanel.ContentView_image_size.width, height: TheControlPanel.ContentView_image_size.height, alignment: .center)
                                        .onAppear {
                                            the_cached.thumbnail = image
                                            
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
                            .onTapGesture {
                                enter_into_the_caching_state()
                                //                                add_the_data_to_the_cache(the_cached)
                            }
                        }
                        
                        
                    }
                }
            } /// THE END of List {}
            // MARK: - toolbar section
            //            .navigationTitle("My Bookself")
            .toolbar {
                
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    
                    VStack(alignment: .center, spacing: 10) {
                        
                        // Mark: - The First Row
                        HStack {
                            Spacer()
                            
                            // MARK: The `TextField` here!
                            TextField("Enter Book Name Here!", text: $search_key, prompt: Text("Enter Book Name like 'mongodb'"))
                                .onSubmit {
                                    //TODO: incomplete. put REST search query here.
                                    
                                    //TODO: The following shall be set after getting at least a result.
                                    textField_mode = .showSearchResult
                                }
                            
                            Spacer()
                        }
                        .padding(.top, 15)
                        
                        // Mark: - The 2dn Row
                        HStack(alignment: .top, spacing: 0) {
                            Spacer()
                            Text("Recently Searched")
                                .font(.headline)
                                .frame(width: 200, alignment: .topLeading)
                            Spacer()
                            Button {
                                the_visited_cache_store.the_visited_cached.removeAll(keepingCapacity: true)
                            } label: {
                                Text("Clear")
                                    .font(.headline)
                                    .foregroundColor(Color.red)
                                    .frame(width: 50, alignment: .topTrailing)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            Spacer()
                        }
                        .padding(.bottom, 10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    
                }
            } /// THE END of .toolbar {}
            
        } /// THE END of NavigationView
        
    }
    
    /// `func add_the_data_to_the_cache()`
    ///  Adding the data to the cache.
    ///
    ///  ** ASSUMPTION **
    /// when tapped, textField_mode == .showCached
    /// To paraphrase it, when tapping the searched item, it will be cached,
    func add_the_data_to_the_cache(_ the_cached: TheVisitedCached) {
        enter_into_the_caching_state()
        /// When clicking the NavigationLink, it will cache it by appending it
        the_visited_cache_store.the_visited_cached.insert(TheVisitedCached(title: the_cached.title, isbn13: the_cached.isbn13, image_string: the_cached.image_string, thumbnail: the_cached.thumbnail))
    }
    
    func enter_into_the_caching_state() {
        textField_mode = .showCached
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(the_visited_cache_store: preview_of_the_visited_cache_store).preferredColorScheme(.dark)
            
            ContentView(the_visited_cache_store: preview_of_the_visited_cache_store).preferredColorScheme(.light)
        }
    }
}
