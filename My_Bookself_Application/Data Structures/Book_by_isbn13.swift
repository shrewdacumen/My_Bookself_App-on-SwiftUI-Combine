//
//  Book_by_isbn13.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/18/22.
//

import Foundation
import SwiftUI

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

struct Book_by_isbn13: Identifiable, Codable {
    let error: Int
    let title: String
    let subtitle: String
    let authors: String
    let publisher: String
    let isbn10: String
    
    /// Use isbn13 as `id`
    let id: String
    let pages: Int
    let year: String
    let rating: Int
    let desc: String
    let price: String
    let image: String /// later, it turns Image
    let url: String  /// later, it turns URL
    let pdf: [String : URL]
}
