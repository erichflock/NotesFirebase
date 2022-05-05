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
        guard let databaseReference = createDatabaseReference() else { return }
        
        let query = databaseReference.queryOrdered(byChild: "/date")
        
        query.observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { [weak self] snapshot, key in
            guard let self = self else { return }
            
            let dispatchGroup = DispatchGroup()
            let children = snapshot.children
            
            dispatchGroup.enter()
            
            var updatedNotes: [Note] = []
            
            for child in children {
                let childSnapshot = child as? DataSnapshot
                guard let childNote = childSnapshot?.value as? NSDictionary else { return }
                
                if let key = childSnapshot?.key, let noteText = childNote.value(forKey: "note") as? String {
                    let note = Note(key: key, text: noteText)
                    updatedNotes.append(note)
                }
            }
            dispatchGroup.leave()
            dispatchGroup.notify(queue: .main) {
                self.notes = updatedNotes
            }
        })
    }
    
    func deleteNote(noteKey: String) {
        guard let databaseReferece = createDatabaseReference() else { return }
        
        databaseReferece.observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { [weak self] snapshot, key in
            guard let self = self else { return }
            
            let dispatchGroup = DispatchGroup()
            let children = snapshot.children
            
            dispatchGroup.enter()
            
            for child in children {
                let childSnapshot = child as? DataSnapshot
                guard let key = childSnapshot?.key else { return }
                
                if noteKey == key {
                    databaseReferece.child(noteKey).removeValue()
                }
            }
            
            dispatchGroup.leave()
            dispatchGroup.notify(queue: .main) {
                self.updateNotes()
            }
        })
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
    
    //Helper Functions
    private func createDatabaseReference() -> DatabaseReference? {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("error: user id not available. Please, sign in again.")
            return nil
        }
        
        return databaseReference.child("users").child(userID).child("notes")
    }
    
}
