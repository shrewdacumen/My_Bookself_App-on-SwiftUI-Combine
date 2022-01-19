//
//  urlByURLComponents.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/18/22.
//

import Foundation

enum IT_BookStore_API_kind: String {
    case search
    case new
    case books
}

/// ** Function **
///  Returns the proper URL based on `IT_BookStore_API_kind`.
///  Because the app is going to utilize 3 parts of IT Bookstore API, this will consolidate all the works.
/// - Parameters:
/// - last_path_string: the last specific string for query.  It can be the isbn13 number, new or the query text on the TextField from ContentView
/// - IT_BookStore_API_kind: IT Bookstore API has 3 different kinds.  search, new, books
/// - page: the page number when `.search` is selected.
/// - Returns: URL
func urlByURLComponents(last_path_string: String, IT_BookStore_API_kind: IT_BookStore_API_kind, page: Int? = nil) -> URL {
    var urlComponents = URLComponents()
    
    urlComponents.scheme = "https"
    urlComponents.host = "api.itbook.store"
    
    /// page is not nil
    if let page = page {
        guard IT_BookStore_API_kind == .search else {
            fatalError("WRONG USAGE: IT_BookStore_API_kind should be .search")
        }
        urlComponents.path = ((("/1.0" as NSString).appendingPathComponent(IT_BookStore_API_kind.rawValue) as NSString).appendingPathComponent(last_path_string) as NSString).appendingPathComponent(String(page))
    } else { /// page is nil
        urlComponents.path = (("/1.0" as NSString).appendingPathComponent(IT_BookStore_API_kind.rawValue) as NSString).appendingPathComponent(last_path_string)
    }
    
    print("urlString = \(String(describing: urlComponents.string))")
    
    guard let url = urlComponents.url else {
        
        /// This will only happen when it is under development.
        fatalError("wrong url")
    }
    
    return url
}
