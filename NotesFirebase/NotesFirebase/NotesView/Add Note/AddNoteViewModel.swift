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
    
    private var user: User? {
        if let data = UserDefaults.standard.value(forKey: "user") as? Data {
            let user = try? PropertyListDecoder().decode(User.self, from: data)
            return user
        } else {
            return nil
        }
    }
    
    @Published var note = placeholder
    
    func saveNote() {
        guard !note.isEmpty, note != AddNoteViewModel.placeholder else {
            print("error: note is empty.")
            return
        }
        
        guard let userID = user?.uid else {
            print("error: user id not available.")
            return
        }
        
        let databaseReference = Database.database().reference()
        
        guard let key = databaseReference.child(userID).child("posts").childByAutoId().key else {
            print("error: error while creating key")
            return
        }
        
        guard let userName = user?.name else { return }
        
        let post = ["date": Date().formatted(date: .abbreviated, time: .standard),
                    "userUid": userID,
                    "userName": userName,
                    "note": note]
        
        let childUpdates = ["/users/\(userID)/notes/\(key)": post]
        
        databaseReference.updateChildValues(childUpdates)
    }

}
