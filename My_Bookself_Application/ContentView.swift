//
//  ContentView.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/17/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var the_store: Store_of_saved_searches
    
    @State var search_key: String = ""
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Spacer()
                TextField("Enter Book Name Here!", text: $search_key)
                    .onSubmit {
                        //TODO: incomplete. put REST search query here.
                    }
                Spacer()
            }
            .padding(.top, 15)

            
            HStack(alignment: .top, spacing: 0) {
                Spacer()
                Text("Recently Searched")
                Spacer()
                Button {
                    the_store.saved_searches.removeAll(keepingCapacity: true)
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
                ForEach(the_store.saved_searches) { saved_search in
                    VStack(alignment: .center, spacing: 5) {
                        Text(saved_search.id)
                            .fontWeight(.ultraLight)
                        Text(saved_search.title)
                            .font(.headline)
                        
                        // TODO: incomplete. put NavgationLink here
                        saved_search.thumbnail
                    }
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(the_store: preview_store).preferredColorScheme(.dark)
            
            ContentView(the_store: preview_store).preferredColorScheme(.light)
        }
    }
}
