#  Exercise Project `My_Bookself_App on SwiftUI & Combine`

## Xcode Environment:
Xcode Version 13.2.1 (13C100)
iOS deployment target 15.2 (15.0 up compatible)
Orientation: .portrait

## Software Version Requirement:
language: Swift 5.5
frameworks: SwiftUI 3.0, Combine

-- Created by Sungwook Kim
   Jan 19 2022


### This project is designed and developed in the mind of a limited time frame: possibly 3 hours, the goal. 

## motif in the whole design:
- Consider `Music.app` that is an Apple's offcial iOS app.
   esp., in the functions and actions in initiating the search on the textField.

## The REST endpoint used in this project
   Please follow up the link for more infomation: [IT Bookstore API](https://api.itbook.store/)

## App Structure:
 Please see the file `App Structure.png` file contained in this repository. 

## Test-Driven Development:
1. XCTests: mainly located on the file `My_Bookself_ApplicationTests.swift`
2. system wide TESTs: The extensive uses of fatalError() and assert() across all Swift sources 
3. It is being done through the manual settings like `TDD_SETTING` on `struct TheControlPanel`
    For example, `static let TDD_SETTING = TESTING_STATE.RELEASE` for RELEASE.
    static let TDD_Setting = TESTING_STATE.TEST_BookView for pinpointing the TEST on the SwiftUI view `BookView`.


## ContentView, a SwiftUI view, also called `Search` in the `App Structure.png` picture.
- Endpoint​: https://api.itbook.store/1.0/search/{query}
- Endpoint (with pagination)​: https://api.itbook.store/1.0/search/{query}/{page}
- It caches the search data that is stored as `the_visited_cache_store` in this project.
- The first view when the user launch the app.
- TheVisitedCached and Store_of_The_Visited_Cached are both the view models which supports `ContentView`


## BookView, a SwiftUI view, also called `Detail Book` in the `App Structure.png` picture.
- Endpoint​: https://api.itbook.store/1.0/books/{isbn13}
- Allows the user to take a note.
- Connects hyperlink with the book’s URL.
- The subsequent view being presented by ContentView (through NavigationView).
- It get its data from the remote endpoint "IT Bookstore API/books"
- The Codable `struct Book_by_isbn13` is the placeholder JSON structure.
- And `class GetTheSelectedBook` is designed for fetching the remote data from the endpoint through
     it member function `func get_the_selected_book(isbn13: String)` based on the native `Combine framework` of Apple Inc.


## TheControlPanel struct
- It contains Test-Driven Development features.
- It controls the global setting across all the sources of the app.

