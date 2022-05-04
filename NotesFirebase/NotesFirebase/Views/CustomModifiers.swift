//
//  CustomModifiers.swift
//  NotesFirebase
//
//  Created by Erich Flock on 04.05.22.
//

import SwiftUI

struct StandardButtonStyle: ViewModifier {
    
    let size: ControlSize
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(.bordered)
            .tint(.blue)
            .controlSize(size)
    }
    
}

extension View {
    
    func standardButton() -> some View {
        modifier(StandardButtonStyle(size: .regular))
    }
    
}

struct CloseButtonStyle: ViewModifier {
    
    let size: ControlSize
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderless)
            .tint(.red)
            .controlSize(size)
    }
    
}
