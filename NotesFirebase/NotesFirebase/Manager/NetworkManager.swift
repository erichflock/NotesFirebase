//
//  NetworkManager.swift
//  NotesFirebase
//
//  Created by Erich Flock on 06.05.22.
//

import FirebaseDatabase
import FirebaseAuth

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let databaseReference = Database.database().reference()
    
    private init() {}
    
    func getNotes(completion: @escaping ([Note]) -> ()) {
        guard let databaseReference = createDatabaseReference() else { return }
        
        let query = databaseReference.queryOrdered(byChild: "/date")
        
        query.observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { snapshot, key in
            
            let dispatchGroup = DispatchGroup()
            let children = snapshot.children
            
            dispatchGroup.enter()
            
            var notes: [Note] = []
            
            for child in children {
                let childSnapshot = child as? DataSnapshot
                guard let childNote = childSnapshot?.value as? NSDictionary else { return }
                
                if let key = childSnapshot?.key, let noteText = childNote.value(forKey: "note") as? String {
                    let note = Note(key: key, text: noteText)
                    notes.append(note)
                }
            }
            
            dispatchGroup.leave()
            dispatchGroup.notify(queue: .main) {
                completion(notes)
            }
        })
    }
    
    func deleteNote(noteKey: String, completion: @escaping (Bool) -> ()) {
        guard let databaseReferece = createDatabaseReference() else {
            completion(false)
            return
        }
        
        databaseReferece.observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { snapshot, key in
            
            let dispatchGroup = DispatchGroup()
            let children = snapshot.children
            
            dispatchGroup.enter()
            
            for child in children {
                let childSnapshot = child as? DataSnapshot
                guard let key = childSnapshot?.key else {
                    completion(false)
                    return
                }
                
                if noteKey == key {
                    databaseReferece.child(noteKey).removeValue()
                }
            }
            
            dispatchGroup.leave()
            dispatchGroup.notify(queue: .main) {
                completion(true)
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
