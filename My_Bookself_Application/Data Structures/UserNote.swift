//
//  UserNote.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/20/22.
//

import SwiftUI

/// This is letting the user to take a note on BookView (or DetailBook in the diagram)
/// And this is stored persistently that each book has its own user note that has been stored.
class UserNote: ObservableObject {
    /// The actual data format: [ isbn13 ; user_note_string ]
    @Published var notes = [String:String]()
}
