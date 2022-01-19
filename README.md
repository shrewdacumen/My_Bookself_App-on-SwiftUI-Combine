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


# Test-Driven Development:
1. XCTests: mainly located on the file `My_Bookself_ApplicationTests.swift`
2. system wide TESTs: The extensive uses of fatalError() and assert() across all Swift sources 
3. It is being done through the manual settings like `TDD_SETTING` on `struct TheControlPanel`
    For example, `static let TDD_SETTING = TESTING_STATE.RELEASE` for RELEASE.
    static let TDD_Setting = TESTING_STATE.TEST_BookView for pinpointing the TEST on the SwiftUI view `BookView`.
