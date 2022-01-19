//
//  ContentView.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/17/22.
//

///- Endpoint​: https://api.itbook.store/1.0/search/{query}
///   However, the above does NOT produce full query result but the same as `https://api.itbook.store/1.0/search/{query}/1`
///   And this is found by my experiment.
///
///- Endpoint (with pagination)​: https://api.itbook.store/1.0/search/{query}/{page}
///    The last page can NOT be known until the app reached the next to the final page.
///
///    For example, let's say that 8 is the final page to query. And then, `curl https://api.itbook.store/1.0/search/mongodb/9` will produce
///    `{"error":"0","total":"0","page":"9","books":[]}`
///
///    , whereas the query on the final page 8 produces
///    `{"error":"0","total":"71","page":"8","books":[{"title":"Seven Databases in Seven Weeks","subtitle":"A Guide to Modern Databases and the NoSQL Movement","isbn13":"9781934356920","price":"$12.59","image":"https://itbook.store/img/books/9781934356920.png","url":"https://itbook.store/books/9781934356920"}]}`
///
///    The only way to know what is the final page is to query the page pass to the final page 8, in this case, 9.


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
    
    //TODO: incomplete. currently, it has no function.
    @State var textField_mode: TheTextFieldMode = .showCached
    @ObservedObject var get_the_search_results = Get__Search_Results()
    
    var body: some View {
        
        NavigationView {
            
            List {
                
                // Mark: - This section that lists the searched results
                
                /// As soon as it has a search_results,
                if get_the_search_results.does_it_have_search_results() {
                    
                    let the_search_results_1_or_2 = get_the_search_results.the_search_results[1] ?? get_the_search_results.the_search_results[2]
                    
                    ForEach(the_search_results_1_or_2!.books, id: \.isbn13) { each_book_InTheSearchResults in
                        
                        NavigationLink(destination: BookView(isbn13: each_book_InTheSearchResults.isbn13, the_visited_cache_store: the_visited_cache_store, the_visited_cached: TheVisitedCached(title: each_book_InTheSearchResults.title, isbn13: each_book_InTheSearchResults.isbn13, image_string: each_book_InTheSearchResults.image, thumbnail: nil))) {
                            VStack(alignment: .center, spacing: 5) {
                                Text(each_book_InTheSearchResults.isbn13)
                                    .fontWeight(.light)
                                Text(each_book_InTheSearchResults.title)
                                    .font(.headline)
                                Text(each_book_InTheSearchResults.subtitle)
                                    .font(.body)
                                Text(each_book_InTheSearchResults.price)
                            }
                        }
                        
                        AsyncImage(url: URL(string: each_book_InTheSearchResults.image)) { image in
                            image
                                .resizable()
                                .frame(width: TheControlPanel.ContentView_image_size.width, height: TheControlPanel.ContentView_image_size.height, alignment: .center)
                        } placeholder: {
                            ZStack {
                                Text("Loading ...")
                                    .foregroundColor(Color.yellow)
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                    .frame(width: TheControlPanel.ContentView_image_size.width, height: TheControlPanel.ContentView_image_size.height, alignment: .center)
                                    .foregroundColor(Color.blue)
                            }
                        }
                        .frame(width: TheControlPanel.ContentView_image_size.width, height: TheControlPanel.ContentView_image_size.height, alignment: .center)
                        //                        .padding(.top, 15)
                        //                        .padding(.bottom, 15)
                        
                        
                        HStack {
                            Text("URL")
                                .padding(.trailing, 20)
                            Link("Click to Open", destination: URL(string: each_book_InTheSearchResults.url)!)
                        }
                        
                    } /// THE END of ForEach(the_search_results_1_or_2!.books, id: \.isbn13) { each_book_InTheSearchResults in
                    .onAppear {
                        textField_mode = .showSearchResult
                    }
                    .onDisappear {
                        textField_mode = .showCached
                    }
                    
                } else {
                    
                    // Mark: - This section that caches the visited books
                    /// that is stored as `the_visited_cache_store` in this project.
                    ///
                    /// **NOTE**
                    /// `sorted()` was being used as a makeshit to remove an error that
                    ///   Generic struct 'ForEach' requires that 'Set<TheVisitedCached>' conform to 'RandomAccessCollection'
                    ForEach(the_visited_cache_store.the_visited_cached.sorted(), id: \.self) { the_cached in
                        
                        VStack(alignment: .center, spacing: 5) {
                            NavigationLink(destination: BookView(isbn13: the_cached.isbn13, the_visited_cache_store: the_visited_cache_store, the_visited_cached: TheVisitedCached(title: the_cached.title, isbn13: the_cached.isbn13, image_string: the_cached.image_string, thumbnail: the_cached.thumbnail))) {
                                VStack(alignment: .center, spacing: 5) {
                                    Text(the_cached.isbn13)
                                        .fontWeight(.light)
                                    Text(the_cached.title)
                                        .font(.headline)
                                }
                            }
                            
                            /// When the cached `thumbnail` exists, given that the whole cache exits.
                            if let thumbnail = the_cached.thumbnail {
                                
                                thumbnail
                                
                            } else { /// Those cases of both BEFORE thumbnail is cached or when it is being used by ContentView_Previews
                                
                                AsyncImage(url: URL(string: the_cached.image_string)) { image in
                                    image
                                        .resizable()
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
                                .frame(width: TheControlPanel.ContentView_image_size.width, height: TheControlPanel.ContentView_image_size.height, alignment: .center)
                                //                                .padding(.top, 15)
                                //                                .padding(.bottom, 15)
                                
                            }
                            
                        } /// THE END OF VStack(alignment: .center, spacing: 5) {
                        
                    } /// THE END OF ForEach(the_visited_cache_store.the_visited_cached.sorted(), id: \.self) { the_cached in
                    
                    
                } /// THE END of  } else {
                
                
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
                                    
                                    /// remove the previous search results.
                                    get_the_search_results.cleanUp()
                                    get_the_search_results.get_the_search_results(search_key: search_key)
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
            .onDisappear {
                get_the_search_results.cancel_all_threads()
//                                get_the_search_results.cleanUp()
            }
            
        } /// THE END of NavigationView
        
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
