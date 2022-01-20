//
//  My_Bookself_ApplicationTests.swift
//  My_Bookself_ApplicationTests
//
//  Created by sungwook on 1/17/22.
//

import XCTest
import SwiftUI
import Combine
@testable import My_Bookself_Application

class My_Bookself_ApplicationTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    /// #35323E Grayish Violet
    func test_Color35323E() {
        
        let rgbColor = rgbaValue(hex_string: "#35323E")
        
        XCTAssertNotNil(rgbColor)
        XCTAssertEqual(rgbColor!.r, 53.0/255.0)
        XCTAssertEqual(rgbColor!.g, 50.0/255.0)
        XCTAssertEqual(rgbColor!.b, 62.0/255.0)
        XCTAssertEqual(rgbColor!.a, 1.0)
        
    }
    
    ///  #232127 Very Dark Violet
    func test_Color232127() {
        
        let rgbColor = rgbaValue(hex_string: "#232127")
        
        XCTAssertNotNil(rgbColor)
        XCTAssertEqual(rgbColor!.r, 35.0/255.0)
        XCTAssertEqual(rgbColor!.g, 33.0/255.0)
        XCTAssertEqual(rgbColor!.b, 39.0/255.0)
        XCTAssertEqual(rgbColor!.a, 1.0)
    }
    
    func test__class_Get__Search_Results() {
        @ObservedObject var test__get__Search_Results = Get__Search_Results()
        
        test__get__Search_Results.cleanUp()
        test__get__Search_Results.get_the_search_results(search_key: "mongodb")
        
        /// Test after 20 sec.
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(20)) {
            print("\n\n-- This message is from XCT TESTING MODULE --")
            
            XCTAssertTrue(test__get__Search_Results.does_it_have_search_results())
            
            print("The total number of books: \(test__get__Search_Results.books_from_all_pages.count)")
            print("\(test__get__Search_Results.books_from_all_pages)")
        }
    }
}
