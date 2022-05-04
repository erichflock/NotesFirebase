//
//  CustomModifiers.swift
//  NotesFirebase
//
//  Created by Erich Flock on 04.05.22.
//

import SwiftUI

struct StandardButtonStyle: ViewModifier {

    func body(content: Content) -> some View {
        content
            .buttonStyle(.bordered)
            .tint(.blue)
            .controlSize(.large)
    }
    
}

extension View {
    
    func standardButton() -> some View {
        modifier(StandardButtonStyle())
    }
    
}
