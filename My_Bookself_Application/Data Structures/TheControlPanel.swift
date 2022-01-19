//
//  TheControlPanel.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/18/22.
//

import Foundation
import SwiftUI

/// The global values which affects globally.
struct TheControlPanel {
    
    // MARK: - Test Driven Development, TDD
    
    /// The purpose is to test it on the Simulator or the real iOS devices.
    /// When I need to test only the portion `BookView`, set it as the following example, saying, `TDD_Setting = TEST_BookView`
    enum TESTING_STATE { case TEST_BookView, TEST_ContentView, RELEASE }
    /// In order to turn on the testing only BookView uncomment the following
//    static let TDD_Setting = TESTING_STATE.TEST_BookView
    /// When the above is uncommented, the following should be commented out.
    static let TDD_SETTING = TESTING_STATE.RELEASE
    
    
    
    // MARK: - Global Settings
    
    static let BookView_image_size = CGSize(width: 200.0, height: 233)
    static let ContentView_image_size = CGSize(width: 100.0, height: 117)
}
