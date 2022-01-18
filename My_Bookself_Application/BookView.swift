//
//  BookView.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/18/22.
//

import SwiftUI

struct BookView: View {
    let isbn13: String
    @State var the_selected_book: Book_by_isbn13?
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            
            if let the_selected_book = the_selected_book {
                
                HStack {
                    Text("isbn13")
                    Text(isbn13)
                        .fontWeight(.ultraLight)
                }
                
                Text(the_selected_book.title)
                
                Text(the_selected_book.subtitle)
                
                Text(the_selected_book.authors)
                
                Text(the_selected_book.publisher)
                
                Text(the_selected_book.isbn10)
            } else { /// This is for debugging
                #if DEBUG
                Text(isbn13)
                    .fontWeight(.ultraLight)
                #endif
            }
        }
        .onAppear {
            
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        /// When isbn13 becomes @Binding var
        // BookView(isbn13: Binding(get: { preview_of_the_visited_cache_store.the_visited_cached.first!.isbn13 }, set: {_ in }))
        BookView(isbn13: preview_of_the_visited_cache_store.the_visited_cached.first!.isbn13 )
    }
}
