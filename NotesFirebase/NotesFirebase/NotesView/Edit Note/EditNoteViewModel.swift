//
//  EditNoteViewModel.swift
//  NotesFirebase
//
//  Created by Erich Flock on 05.05.22.
//

import SwiftUI

class EditNoteViewModel: ObservableObject {
    
    static let placeholder = "Please, type your note"
    @Published var noteText = placeholder
    
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
