//
//  ContentView.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/17/22.
//

import SwiftUI

struct ContentView: View {
    enum TheTextFieldMode {
        /// when tapping the textField and it is before the search execution by pressing the enter key.
        case showCached
        /// the mode when the search result is about to see or shown.
        case showSearchResult
    }
    
    @ObservedObject var the_visited_cache_store: Store_of_The_Visited_Cached
    
    @State var search_key: String = ""
    @State var textField_mode: TheTextFieldMode = .showCached
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Spacer()
                TextField("Enter Book Name Here!", text: $search_key)
                    .onSubmit {
                        //TODO: incomplete. put REST search query here.
                        textField_mode = .showSearchResult
                    }
                Spacer()
            }
            .padding(.top, 15)

            
            HStack(alignment: .top, spacing: 0) {
                Spacer()
                Text("Recently Searched")
                Spacer()
                Button {
                    the_visited_cache_store.the_visited_cached.removeAll(keepingCapacity: true)
                } label: {
                    Text("Clear")
                        .font(.headline)
                        .foregroundColor(Color.red)
                }
                Spacer()
            }
            
        }
            
        Divider()
        
        NavigationView {
            List {
                ForEach(the_visited_cache_store.the_visited_cached) { the_visited_cached in
                    VStack(alignment: .center, spacing: 5) {
                        Text(the_visited_cached.isbn13)
                            .fontWeight(.ultraLight)
                        Text(the_visited_cached.title)
                            .font(.headline)
                        
                        // TODO: incomplete. put NavgationLink here
                        the_visited_cached.thumbnail
                    }
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(the_visited_cache_store: preview_store).preferredColorScheme(.dark)
            
            ContentView(the_visited_cache_store: preview_store).preferredColorScheme(.light)
        }
    }
}
