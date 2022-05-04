//
//  AddNoteViewModel.swift
//  NotesFirebase
//
//  Created by Erich Flock on 04.05.22.
//

import SwiftUI

class AddNoteViewModel: ObservableObject {
    
    static let placeholder = "Please, type your note"
    
    @Published var note = placeholder
}
