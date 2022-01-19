#  Exercise Project `My_Bookself_Application`

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

## Test-Driven Development:
1. XCTests: mainly located on the file `My_Bookself_ApplicationTests.swift`
2. system wide TESTs: The extensive uses of fatalError() and assert() across all Swift sources 
3. It is being done through the manual settings like `TDD_SETTING` on `struct TheControlPanel`
    For example, `static let TDD_SETTING = TESTING_STATE.RELEASE` for RELEASE.
    static let TDD_Setting = TESTING_STATE.TEST_BookView for pinpointing the TEST on the SwiftUI view `BookView`.


## BookView, a SwiftUI view
- The subsequent view being presented by ContentView (through NavigationView).
- It get its data from the remote endpoint "IT Bookstore API/books"
- The Codable `struct Book_by_isbn13` is the placeholder JSON structure.
- And `class GetTheSelectedBook` is designed for fetching the remote data from the endpoint through
     it member function `func get_the_selected_book(isbn13: String)` based on the native `Combine framework` of Apple Inc.

## ContentView, a SwiftUI view
- The first view when the user launch the app.
- TheVisitedCached and Store_of_The_Visited_Cached are both the view models which supports `ContentView`

## TheControlPanel struct
- It contains Test-Driven Development features.
- It controls the global setting across all the sources of the app.

