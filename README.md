# Exercise Project `My_Bookshelf_App on SwiftUI & Combine`

## Copyright (c) 2022 by Sungwook Kim
## This work is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License.
## https://creativecommons.org/licenses/by-nc/4.0/
## However, anyone who has donated can use it as OPEN SOURCE with ATTRIBUTION ASSURANCE LICENSE.


## The DEMO video
   Please click to watch the demo video:
   [Demo Video](https://youtu.be/IQaLHInpRnw)

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
For example,
    func test__class_Get__Search_Results() under class My_Bookself_ApplicationTests are one of XCT test functions.
    Without this, I have tested many times those REST related functions and multi-threading codes in other ways.    


## ContentView, a SwiftUI view, also called `Search` in the `App Structure.png` picture.
## The implementation for `Search` in the diagram.
- Endpoint​: https://api.itbook.store/1.0/search/{query}
   However, the above does NOT produce full query result but the same as `https://api.itbook.store/1.0/search/{query}/1`
   And this is found by my experiment. 
   
- Endpoint (with pagination)​: https://api.itbook.store/1.0/search/{query}/{page}
    The last page can NOT be known until the app reached the next to the final page.
    
    For example, let's say that 8 is the final page to query. And then, `curl https://api.itbook.store/1.0/search/mongodb/9` will produce
    `{"error":"0","total":"0","page":"9","books":[]}`
    
    , whereas the query on the final page 8 produces
    `{"error":"0","total":"71","page":"8","books":[{"title":"Seven Databases in Seven Weeks","subtitle":"A Guide to Modern Databases and the NoSQL Movement","isbn13":"9781934356920","price":"$12.59","image":"https://itbook.store/img/books/9781934356920.png","url":"https://itbook.store/books/9781934356920"}]}`
    The only way to know what is the final page is to query the page pass to the final page 8, in this case, 9. 
- It caches the search data that is stored as `the_visited_cache_store` in this project.
- The first view when the user launch the app.
- TheVisitedCached and Store_of_The_Visited_Cached are both the view models which supports `ContentView`
### Data Structure `Search_Results` 
    The JSON placeholder data structure of IT Bookstore API/search in Swfit.
### Data Structure `A_Book`
    The JSON placeholder data structure of IT Bookstore API/search in Swfit.
### Data Structure `class Get__Search_Results`
    It is designed for fetching the remote data from the endpoint through
    its member function `func get_the_search_results(search_key: String)` based on the native `Combine framework` of Apple Inc.
    And the function `get_all_rest_pages(search_key: search_key, to: number_of_pages__estimated)` of this class
     actually finalize all the fetching processes by multi-threading.

## BookView, a SwiftUI view, also called `Detail Book` in the `App Structure.png` picture.
## The implementation for `DetailBook` in the diagram.
- Endpoint​: https://api.itbook.store/1.0/books/{isbn13}
- Allows the user to take a note.
- Connects hyperlink with the book’s URL.
- The subsequent view being presented by ContentView (through NavigationView).
- It get its data from the remote endpoint "IT Bookstore API/books" 
### Data Structure `Book_by_isbn13`
    The JSON placeholder data structure of IT Bookstore API/books in Swfit.     
### Data Structure `class GetTheSelectedBook`
    It is designed for fetching the remote data from the endpoint through
    its member function `func get_the_selected_book(isbn13: String)` based on the native `Combine framework` of Apple Inc.
### Data Structure`class UserNote`
  This is letting the user to take a note on BookView (or DetailBook in the diagram).
  And this is stored persistently that each book has its own user note that has been stored.
     
     
## TheControlPanel struct
- It contains Test-Driven Development features.
- It controls the global setting across all the sources of the app.

## Helper functions, including `func urlByURLComponents`
/// ** Func urlByURLComponents **
///  Returns the proper URL based on `IT_BookStore_API_kind`.
///  Because the app is going to utilize 3 parts of IT Bookstore API, this will consolidate all the works.
/// - Parameters:
/// - last_path_string: the last specific string for query.  It can be the isbn13 number, new or the query text on the TextField from ContentView
/// - IT_BookStore_API_kind: IT Bookstore API has 3 different kinds.  search, new, books
/// - page: the page number when `.search` is selected.
/// - Returns: URL
func urlByURLComponents(last_path_string: String, IT_BookStore_API_kind: IT_BookStore_API_kind, page: Int? = nil) -> URL 


## The Main Mechanic
As the motif of Music.app, item 1 was added.
And there are two kinds of cache system that makes the design & the code complicated.
But this is what I had understood through the close study on Apple's official `Music.app`.
 
1. When the `search_key` on the TextField is "" or empty, ContentView (the first page) will display the list of the cached visited books.
2. When the keyword produces nothing, it will be notified with red Text on top of the list on the first page.
3. Otherwise, the previous searched list (that are also cached) will be displayed instead.

