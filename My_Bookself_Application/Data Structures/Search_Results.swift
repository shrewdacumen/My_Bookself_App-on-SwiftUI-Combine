//
//  Search_Results.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/18/22.
//

import Foundation
import Combine


/**
 Captured from the example:
 {
     "total": "48",
     "page": "1",
     "books": [
         {
             "title": "Practical MongoDB",
             "subtitle": "Architecting, Developing, and Administering MongoDB",
             "isbn13": "9781484206485",
             "price": "$32.04",
             "image": "https://itbook.store/img/books/9781484206485.png",
             "url": "https://itbook.store/books/9781484206485"
         },
         {
             title": "The Definitive Guide to MongoDB, 3rd Edition",
             subtitle": "A complete guide to dealing with Big Data using MongoDB",
             isbn13": "9781484211830",
             price": "$47.11",
             image": "https://itbook.store/img/books/9781484211830.png",
             url": "https://itbook.store/books/9781484211830"
         },
         {
             "title": "MongoDB in Action, 2nd Edition",
             "subtitle": "Covers MongoDB version 3.0",
             "isbn13": "9781617291609",
             "price": "$32.10",
             "image": "https://itbook.store/img/books/9781617291609.png",
             "url": "https://itbook.store/books/9781617291609"
         },
         ...
     ]
 }
 */

/// `Search_Results`
/// The JSON placeholder data structure of IT Bookstore API/search in Swfit.
struct Search_Results: Codable {
    let total: Int
    let page: Int
    let books: [A_Book]
}

/// `A_Book`
/// The JSON placeholder data structure of IT Bookstore API/search in Swfit.
struct A_Book: Codable {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    let url: String
}


/// This data structure is for getting the REST data from IT Bookstore API/search
/// that is necessary for `ContentView`
class Get__Search_Results: ObservableObject {
    @Published var the_search_results: Search_Results?
    
    /// this is used to cancel any subscription.
    var cancellables = Set<AnyCancellable>()
    
    func get_the_search_results(search_key: String) {
        //TODO: incomplete.  Try first the 1st page. Later, complete the rest.
        let url = urlByURLComponents(last_path_string: search_key, IT_BookStore_API_kind: .search, page: 1)
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode (type: Search_Results.self, decoder: JSONDecoder())
            .sink { (completion_state) in
                switch completion_state {
                case .finished:
#if DEBUG
                    print("It is finished!")
                    print("\(String(describing: self.the_search_results))")
                    /// Testing!
                    assert(self.the_search_results != nil)
#else
                    break
#endif
                    
                case .failure(let error):
#if DEBUG
                    print("There was an error \(error)")
#else
                    break
#endif
                }
            } receiveValue: { [unowned self] (returnedPosts) in
                self.the_search_results = returnedPosts
            }
            .store(in: &cancellables)
    }
    
    func handleOutput (output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                  throw URLError(.badServerResponse)
              }
        return output.data
    }
    
    deinit {
        cancellables.forEach {
            $0.cancel()
        }
        the_search_results = nil
    }
    
    /// cancel all ongoing tasks of getting data from the remote endpoints.
    func cleanUp() {
        cancellables.forEach {
            $0.cancel()
        }
        the_search_results = nil
    }
}



