//
//  NotesViewModel.swift
//  NotesFirebase
//
//  Created by Erich Flock on 04.05.22.
//

import SwiftUI

class NotesViewModel: ObservableObject {
    
    @Published var notes: [String] = []
    
}
