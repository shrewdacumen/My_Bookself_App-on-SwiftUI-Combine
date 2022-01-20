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

/// The implementation for `Search` in the diagram.
struct ContentView: View {
    
    @ObservedObject var the_visited_cache_store: Store_of_The_Visited_Cached
    
    @State var search_key = ""
    
    // MARK: PLAN B design
    //    @State var search_key__captured = ""
    //    @State var textField_mode = TheTextFieldMode.showCached
    
    @State var is_NOT_FOUND_MESSGAGE_opacity = 0.0
    
    @StateObject var get_the_search_results = Get__Search_Results()
    
    var body: some View {
        
        NavigationView {
            
            List {
                
                // Mark: - This section that lists the searched results
                
                /// As soon as it has a search_results,
                /// search_key != ""    ---> PLAN A
                /// textField_mode == .showSearchResult   ---> PLAN B
                if get_the_search_results.does_it_have_search_results() && search_key != "" {
 
                    Text("Total Books found: \(get_the_search_results.the_search_results[1]!.total)")
                        .foregroundColor(Color.blue)
                    
                    ForEach(get_the_search_results.books_from_all_pages, id: \.isbn13) { each_book_InTheSearchResults in
                        
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
                        
                        HStack {
                            Text("URL")
                                .padding(.trailing, 20)
                            Link("Click to Open", destination: URL(string: each_book_InTheSearchResults.url)!)
                        }
                        
                    } /// THE END of ForEach(the_search_results_1_or_2!.books, id: \.isbn13) { each_book_InTheSearchResults in
                    
                } else {
                    
                    /// search_key != ""    ---> PLAN A
                    /// textField_mode == .showSearchResult   ---> PLAN B
                    if get_the_search_results.there_are_no_search_results() && search_key != "" {
                        
                        Text("Can't find a book by the keyword \(search_key)")
                            .font(.title)
                            .foregroundColor(Color.red)
                            .opacity(is_NOT_FOUND_MESSGAGE_opacity)
                            .onAppear {
                                withAnimation(.easeIn(duration: 1.0)) {
                                    is_NOT_FOUND_MESSGAGE_opacity = 1.0
                                }
                            }
                    
                    }
                    
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
                                    .resizable()
                                
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
                            
                            // MARK: TextField()
                            TextField("Enter Book Name Here!", text: $search_key, prompt: Text("Enter Book Name like 'mongodb'"))
                            // MARK: onSubmit()
                                .onSubmit {
                                    // MARK: PLAN B design
                                    ///```
                                    /// search_key__captured = search_key
                                    /// textField_mode = .showSearchResult
                                    ///```
                                    /// Reset the current `search_key` after search_ley is captured.
                                    /// This will activate the list of previously visited books that are cached as well.
                                    ///```
                                    /// search_key = ""
                                    ///```
                                    
                                    // MARK: PLAN A design
                                    /// remove the previous search results.
                                    get_the_search_results.cleanUp()
                                    get_the_search_results.get_the_search_results(search_key: search_key)
                                }
                            // MARK: PLAN B design
                            ///```
                            /// .onChange(of: search_key) { newValue in
                            ///     if newValue != "" && newValue != search_key__captured {
                            ///         textField_mode = .showCached
                            ///     }
                            /// }
                            ///```
                            
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
            }
            
        } /// THE END of NavigationView
        
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
