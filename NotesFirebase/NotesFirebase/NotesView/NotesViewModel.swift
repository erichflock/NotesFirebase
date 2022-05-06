//
//  NotesViewModel.swift
//  NotesFirebase
//
//  Created by Erich Flock on 04.05.22.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

class NotesViewModel: ObservableObject {
    
    @Published var notes: [Note] = []
    
    let databaseReference = Database.database().reference()
    
    func updateNotes() {
        NetworkManager.shared.getNotes() { [weak self] notes in
            self?.notes = notes
        }
    }
    
    func deleteNote(noteKey: String) {
        NetworkManager.shared.deleteNote(noteKey: noteKey) { [weak self] success in
            guard success else {
                print("Error while deleting note with key \(noteKey)")
                return
            }
            
            self?.updateNotes()
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        offsets.forEach({
            guard notes.count > $0 else { return }
            let key = notes[$0].key
            deleteNote(noteKey: key)
        })
        
        notes.remove(atOffsets: offsets)
    }
    
    ///Return first 3 words of note
    func getTitle(_ note: String) -> String? {
        let noteWithoutLineBreak = note.replacingOccurrences(of: "\n", with: " ")
        let words = noteWithoutLineBreak.components(separatedBy: " ")
        
        var firstThreeWords: [String] = []
        
        words.forEach({
            if firstThreeWords.count < 3 {
                firstThreeWords.append($0)
            }
        })
        
        var title = ""
        
        firstThreeWords.forEach({
            if title.isEmpty {
                title += "\($0)"
            } else {
                title += " \($0)"
            }
        })
        
        return title
    }

}
