//
//  EditNoteView.swift
//  NotesFirebase
//
//  Created by Erich Flock on 05.05.22.
//

import SwiftUI

struct EditNoteView: View {
    
    @Binding var showingEditNote: Bool
    var note: Note
    @ObservedObject var notesViewModel: NotesViewModel
    @StateObject var viewModel = EditNoteViewModel()
    
    var body: some View {
        VStack {
            VStack() {
                Text("Edit Note")
                    .font(.title)
                
                TextEditor(text: $viewModel.noteText)
                    .foregroundColor(viewModel.noteText == EditNoteViewModel.placeholder ? .gray : .primary)
                    .onTapGesture {
                        if viewModel.noteText == EditNoteViewModel.placeholder {
                            viewModel.noteText = ""
                        }
                    }
            }
            Button {
                viewModel.update(note: note)
                notesViewModel.updateNotes()
                showingEditNote = false
            } label: {
                Text("Save")
            }
            .modifier(StandardButtonStyle(size: .large))
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
        .overlay(XRoundedDismissButton(isShowingView: $showingEditNote), alignment: .topTrailing)
    }
}

struct EditNoteView_Previews: PreviewProvider {
    static var previews: some View {
        EditNoteView(showingEditNote: .constant(false), note: .init(key: "", text: ""), notesViewModel: .init())
    }
}
