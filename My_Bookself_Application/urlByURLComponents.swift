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

func urlByURLComponents(last_path_string: String, IT_BookStore_API_kind: IT_BookStore_API_kind) -> URL {
    var urlComponents = URLComponents()
    
    urlComponents.scheme = "https"
    urlComponents.host = "api.itbook.store"
    urlComponents.path = (("/1.0" as NSString).appendingPathComponent(IT_BookStore_API_kind.rawValue) as NSString).appendingPathComponent(last_path_string)
    
    print("urlString = \(String(describing: urlComponents.string))")
    
    guard let url = urlComponents.url else {
        
        /// This will only happen when it is under development.
        fatalError("wrong url")
    }
    
    return url
}
