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
        
        List {
            
            /// Only after the loading is finished, `the_selected_book` shall be NOT `nil`,
            if let the_selected_book = the_selected_book {
                
                VStack(alignment: .center, spacing: 10) {
                    
                    HStack {
                        Text("title")
                        Text(the_selected_book.title)
                    }
                    
                    HStack {
                        Text("subtitle")
                        Text(the_selected_book.subtitle)
                    }
                    
                    HStack {
                        Text("authors")
                        Text(the_selected_book.authors)
                    }
                    
                    HStack {
                        Text("publisher")
                        Text(the_selected_book.publisher)
                    }
                    
                    HStack {
                        Text("isbn10")
                        Text(the_selected_book.isbn10)
                    }
                    
                    HStack {
                        Text("isbn13")
                        Text(the_selected_book.isbn13)
                            .fontWeight(.ultraLight)
                    }
                    
                    HStack {
                        Text("pages")
                        Text(the_selected_book.pages)
                    }
                    
                    HStack {
                        Text("year")
                        Text(the_selected_book.year)
                    }
                    
                }
                
                /// * CAVEAT *
                /// `VStack` has a limit of 13 views to produce the resulting `View protocol`,
                ///   related to `@ViewBuilder`
                /// * Its Solution *
                /// I fragmented 14 elements by two VStacks.
                VStack(alignment: .center, spacing: 10) {
                    
                    HStack {
                        Text("rating")
                        HStack {
                            ForEach(1...the_selected_book.rating, id: \.self) { _ in
                                Image(systemName: "star.fill")
                            }
                        }
                    }
                    
                    HStack {
                        Text("descrition")
                        Text(the_selected_book.desc)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                    }
                    
                    HStack {
                        Text("price")
                        Text(the_selected_book.price)
                    }
                    
                    AsyncImage(url: URL(string: the_selected_book.image), scale: TheControlPanel.BookView_scale) { phase in
                        if case .success(let image) = phase {
                            image
                                .resizable()
                        }
                    }
                    
                    HStack {
                        Text("URL")
                        Text("[Click Me to Open](\(the_selected_book.url)")
                    }
                    
                    HStack {
                        Text("PDF")
                        VStack {
                            /// ** The Previous Error **
                            /// Generic struct 'ForEach' requires that 'Dictionary<String, String>.Keys' conform to 'RandomAccessCollection'
                            /// ** Its Solution **
                            /// The return value of keys.sorted() has solved under `ForEach()`
                            ForEach(the_selected_book.pdf.keys.sorted(), id: \.self) { key in
                                Text(key)
                                Text("[Click Me to Open](\(the_selected_book.pdf[key]!)")
                            }
                        }
                    }
                    
                }
                
            } else { /// This is only for debugging
#if DEBUG
                Text(isbn13)
                    .fontWeight(.ultraLight)
#endif
            }
            
        } /// THE END OF List {}
        .onAppear {
            // TODO: incomplete. Add loading feature through Combine.
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
