//
//  EditNoteViewModel.swift
//  NotesFirebase
//
//  Created by Erich Flock on 05.05.22.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

class EditNoteViewModel: ObservableObject {
    
    @Published var noteText = ""
    @Published var didSave = false
    
    let databaseReference = Database.database().reference()
    
    func update(note: Note, completion: @escaping () -> ()) {
        NetworkManager.shared.update(note: note, newText: noteText) { [weak self] success in
            self?.didSave = success
            completion()
        }
    }
    
}
