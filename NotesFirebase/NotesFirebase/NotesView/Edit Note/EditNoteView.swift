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
                    .foregroundColor(.primary)
            }
            Button {
                viewModel.update(note: note) {
                    if viewModel.didSave {
                        notesViewModel.updateNotes()
                        showingEditNote = false
                    }
                }
            } label: {
                Text("Save")
                if viewModel.isLoading {
                    ProgressView()
                        .padding([.leading])
                }
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
        .onAppear() {
            viewModel.noteText = note.text
        }
    }
}

struct EditNoteView_Previews: PreviewProvider {
    static var previews: some View {
        EditNoteView(showingEditNote: .constant(false), note: .init(key: "", text: ""), notesViewModel: .init())
    }
}
