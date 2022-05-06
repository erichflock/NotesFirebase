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
    @Published var isLoading = false
    
    let databaseReference = Database.database().reference()
    
    func update(note: Note, completion: @escaping () -> ()) {
        isLoading = true
        NetworkManager.shared.update(note: note, newText: noteText) { [weak self] success in
            self?.isLoading = false
            self?.didSave = success
            completion()
        }
    }
    
}
