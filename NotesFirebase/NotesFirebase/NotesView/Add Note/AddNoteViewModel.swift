//
//  AddNoteViewModel.swift
//  NotesFirebase
//
//  Created by Erich Flock on 04.05.22.
//

import SwiftUI
import FirebaseDatabase

class AddNoteViewModel: ObservableObject {
    
    static let placeholder = "Please, type your note"
    
    @Published var note = placeholder
    
    func saveNote(completion: @escaping () -> ()) {
        guard !note.isEmpty, note != AddNoteViewModel.placeholder else {
            print("error: note is empty.")
            return
        }
        
        NetworkManager.shared.saveNote(text: note) { success in
            completion()
        }
    }

}
