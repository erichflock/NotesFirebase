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
    
    @Published var notes: [String] = []
    
    let databaseReference = Database.database().reference()
    
    func updateNotes() {
        guard let postsReference = createPostsReference() else { return }
        
        let postsQuery = postsReference.queryOrdered(byChild: "/date")
        
        postsQuery.observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { [weak self] snapshot, key in
            guard let self = self else { return }
            
            let dispatchGroup = DispatchGroup()
            let children = snapshot.children
            
            dispatchGroup.enter()
            
            var updatedNotes: [String] = []
            
            for child in children {
                let childSnapshot = child as? DataSnapshot
                guard let childNote = childSnapshot?.value as? NSDictionary else { return }
                
                if let note = childNote.value(forKey: "note") as? String {
                    updatedNotes.append(note)
                }
            }
            dispatchGroup.leave()
            dispatchGroup.notify(queue: .main) {
                self.notes = updatedNotes
            }
        })
    }
    
    func removeRows(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
    
    ///Return first 3 words of note
    func getTitle(_ note: String) -> String? {
        let words = note.components(separatedBy: " ")
        
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
    private func createPostsReference() -> DatabaseReference? {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("error: user id not available. Please, sign in again.")
            return nil
        }
        
        return databaseReference.child("users").child(userID).child("notes")
    }
    
}
