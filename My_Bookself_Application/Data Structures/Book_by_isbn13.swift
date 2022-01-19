//
//  Book_by_isbn13.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/18/22.
//

import Foundation
import SwiftUI
import Combine

/**
 Captured from the example:
{
    "error": "0"
    "title": "Securing DevOps"
    "subtitle": "Security in the Cloud"
    "authors": "Julien Vehent"
    "publisher": "Manning"
    "isbn10": "1617294136"
    "isbn13": "9781617294136"
    "pages": "384"
    "year": "2018"
    "rating": "5"
    "desc": "An application running in the cloud can benefit from incredible efficiencies, but they come with unique security threats too. A DevOps team's highest priority is understanding those risks and hardening the system against them.Securing DevOps teaches you the essential techniques to secure your cloud ..."
    "price": "$26.98"
    "image": "https://itbook.store/img/books/9781617294136.png"
    "url": "https://itbook.store/books/9781617294136"
    "pdf": {
              "Chapter 2": "https://itbook.store/files/9781617294136/chapter2.pdf",
              "Chapter 5": "https://itbook.store/files/9781617294136/chapter5.pdf"
           }
}
*/

struct Book_by_isbn13: Codable {
    let error: String
    let title: String
    let subtitle: String
    let authors: String
    let publisher: String
    let isbn10: String
    let isbn13: String
    let pages: String
    let year: String
    let rating: String
    let desc: String
    let price: String
    let image: String /// later, it turns Image
    let url: String  /// later, it turns URL
    let pdf: [String : String]?
}


/// This data structure is for getting REST data from IT Bookstore API/books
/// that is necessary for `BookView`
class GetTheSelectedBook: ObservableObject {
    @Published var the_selected_book: Book_by_isbn13?
    
    /// this is used to cancel any subscription.
    var cancellables = Set<AnyCancellable>()
    
    func get_the_selected_book(isbn13: String) {
        let url = urlByURLComponents(last_path_string: isbn13, IT_BookStore_API_kind: .books)
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode (type: Book_by_isbn13.self, decoder: JSONDecoder())
            .sink { (completion_state) in
                switch completion_state {
                case .finished:
#if DEBUG
                    print("It is finished!")
                    print("\(String(describing: self.the_selected_book))")
                    /// Testing!
                    assert(self.the_selected_book != nil)
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
                self.the_selected_book = returnedPosts
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
        the_selected_book = nil
    }
    
    /// cancel all ongoing tasks of getting data from the remote endpoints.
    func cleanUp() {
        cancellables.forEach {
            $0.cancel()
        }
        the_selected_book = nil
    }
}

