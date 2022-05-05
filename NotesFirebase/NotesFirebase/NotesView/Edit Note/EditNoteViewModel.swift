//
//  EditNoteViewModel.swift
//  NotesFirebase
//
//  Created by Erich Flock on 05.05.22.
//

import SwiftUI

class EditNoteViewModel: ObservableObject {
    
    @Published var noteText = ""
    
    private var user: User? {
        if let data = UserDefaults.standard.value(forKey: "user") as? Data {
            let user = try? PropertyListDecoder().decode(User.self, from: data)
            return user
        } else {
            return nil
        }
    }
    
    func update(note: Note) {
        
    }
    
}
