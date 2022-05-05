//
//  Note.swift
//  NotesFirebase
//
//  Created by Erich Flock on 05.05.22.
//

import Foundation

struct Note: Identifiable {
    var id: UUID = UUID()
    var key: String
    var text: String
}
