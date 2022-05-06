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
    @Published var isLoading = false
    @Published var note = placeholder
    
    func saveNote(completion: @escaping () -> ()) {
        guard !note.isEmpty, note != AddNoteViewModel.placeholder else {
            print("error: note is empty.")
            return
        }
        
        isLoading = true
        
        NetworkManager.shared.saveNote(text: note) { [weak self] success in
            self?.isLoading = false
            completion()
        }
    }

}
