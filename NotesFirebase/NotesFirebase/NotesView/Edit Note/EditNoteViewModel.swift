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
    
    private var user: User? {
        if let data = UserDefaults.standard.value(forKey: "user") as? Data {
            let user = try? PropertyListDecoder().decode(User.self, from: data)
            return user
        } else {
            return nil
        }
    }
    
    func update(note: Note, completion: @escaping () -> ()) {
        guard let databaseReferece = createDatabaseReference() else {
            completion()
            return
        }
        
        databaseReferece.observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { [weak self] snapshot, key in
            guard let self = self else {
                completion()
                return
            }
            
            let dispatchGroup = DispatchGroup()
            let children = snapshot.children
            
            dispatchGroup.enter()
            
            for child in children {
                let childSnapshot = child as? DataSnapshot
                guard let key = childSnapshot?.key else {
                    completion()
                    return
                }
                databaseReferece.child(key).child("note").setValue(self.noteText)
            }
            
            dispatchGroup.leave()
            dispatchGroup.notify(queue: .main) {
                self.didSave = true
                completion()
            }
        })
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
