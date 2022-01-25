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
    let total: String /// It seems that it is the total number of books to be queried.
    let page: String
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
/// class Get__Search_Results is designed in a way that
///  all books from all pages (from the remote endpoints) will be continuously added to the list.
class Get__Search_Results: ObservableObject {
    /// [ Page_number : SearchResults]
    @Published var the_search_results = [Int : Search_Results]()
    
    /// all books shall be consolidated to `books_from_all_pages` when all the background tasks are done.
    @Published var books_from_all_pages = [A_Book]()
    
    /// this is used to cancel any subscription.
    var cancellables = Set<AnyCancellable>()
    
    func get_the_search_results(search_key: String) {
        let starting_url = urlByURLComponents(last_path_string: search_key, IT_BookStore_API_kind: .search, page: 1)
        URLSession.shared.dataTaskPublisher(for: starting_url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode (type: Search_Results.self, decoder: JSONDecoder())
            .sink { [self] (completion_state) in
                switch completion_state {
                case .finished:
#if DEBUG
                    print("Page #1: It is finished!")
                    print("Page #1: \(String(describing: self.the_search_results[1]))")
                    /// Testing!
                    assert(self.the_search_results[1] != nil)
                    
                    self.books_from_all_pages.append(contentsOf: self.the_search_results[1]!.books)
                    guard let total_number_of_books = Int(self.the_search_results[1]!.total), total_number_of_books > 0 else {
                        return
                    }
                    let num_of_books_in_page_1 = self.the_search_results[1]!.books.count
                    
                    /// get the higher integer from the real number.
                    var number_of_pages__estimated = total_number_of_books/num_of_books_in_page_1
                    if Double(number_of_pages__estimated) < (Double(total_number_of_books)/Double(num_of_books_in_page_1)) {
                        number_of_pages__estimated += 1
                    }
                    
                    guard number_of_pages__estimated >= 2 else {
                        return
                    }
                    
                    /// Finalize all the fetching processes by multi-threading.
                    get_all_rest_pages(search_key: search_key, to: number_of_pages__estimated)
#else
                    break
#endif
                    
                case .failure(let error):
#if DEBUG
                    print("get_the_search_results: There was an error \(error)")
#else
                    break
#endif
                }
            } receiveValue: { [unowned self] (returnedPosts) in
                self.the_search_results[1] = returnedPosts
            }
            .store(in: &cancellables)
        
    }
    
    /// get all the result from page 2...Final_Page.
    func get_all_rest_pages(search_key: String, to the_last_page_number: Int) {
        for current_page in 2...the_last_page_number {
            let current_url = urlByURLComponents(last_path_string: search_key, IT_BookStore_API_kind: .search, page: current_page)
            URLSession.shared.dataTaskPublisher(for: current_url)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap(handleOutput)
                .decode (type: Search_Results.self, decoder: JSONDecoder())
                .sink { (completion_state) in
                    switch completion_state {
                    case .finished:
#if DEBUG
                        print("Page #\(current_page): It is finished!")
                        print("Page #\(current_page): \(String(describing: self.the_search_results[current_page]))")
                        /// Testing!
                        assert(self.the_search_results[current_page] != nil)
                        self.books_from_all_pages.append(contentsOf: self.the_search_results[current_page]!.books)
#else
                        break
#endif
                        
                    case .failure(let error):
#if DEBUG
                        print("get_all_rest_pages: There was an error \(error)")
#else
                        break
#endif
                    }
                } receiveValue: { [unowned self] (returnedPosts) in
                    self.the_search_results[current_page] = returnedPosts
                }
                .store(in: &cancellables)
        }
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
        the_search_results.removeAll(keepingCapacity: true)
        books_from_all_pages.removeAll(keepingCapacity: true)
    }
    
    /// cancel all ongoing tasks of getting data from the remote endpoints.
    func cleanUp() {
        cancellables.forEach {
            $0.cancel()
        }
        the_search_results.removeAll(keepingCapacity: true)
        books_from_all_pages.removeAll(keepingCapacity: true)
    }
    
    func cancel_all_threads() {
        cancellables.forEach {
            $0.cancel()
        }
    }
    
    func does_it_have_search_results() -> Bool {
        guard let the_search_result = the_search_results[1], let num = Int(the_search_result.total), num > 0 else {
            return false
        }
        return true
    }
    
    func there_are_no_search_results() -> Bool {
        guard let the_search_result = the_search_results[1], let num = Int(the_search_result.total), num == 0 else {
            return false
        }
        return true
    }
}

