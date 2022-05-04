//
//  AddNoteView.swift
//  NotesFirebase
//
//  Created by Erich Flock on 04.05.22.
//

import SwiftUI

struct AddNoteView: View {
    
    @Binding var showingAddNote: Bool
    @StateObject var viewModel = AddNoteViewModel()
    
    var body: some View {
        VStack {
            VStack() {
                Text("Add Note")
                    .font(.title)
                
                TextEditor(text: $viewModel.note)
                    .lineLimit(20)
                    .foregroundColor(viewModel.note == AddNoteViewModel.placeholder ? .gray : .primary)
                    .onTapGesture {
                        if viewModel.note == AddNoteViewModel.placeholder {
                            viewModel.note = ""
                        }
                    }
            }
            Button {
                print("Save Note: \(viewModel.note)")
            } label: {
                Text("Save")
            }
            .modifier(StandardButtonStyle(size: .regular))
            .padding([.bottom], 50)
        }
        .padding()
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .topLeading
            )
        .overlay(XRoundedDismissButton(isShowingView: $showingAddNote), alignment: .topTrailing)
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView(showingAddNote: .constant(false))
    }
}
