//
//  NotesView.swift
//  NotesFirebase
//
//  Created by Erich Flock on 04.05.22.
//

import SwiftUI

struct NotesView: View {
    
    @StateObject var viewModel = NotesViewModel()
    @State var showingAddNote = false
    @State var showingEditNote = false
    @State private var selectedNote: Note? {
        didSet {
            if selectedNote != nil {
                showingEditNote.toggle()
            }
        }
    }
    
    var body: some View {
        VStack {
            List() {
                ForEach(viewModel.notes) { note in
                    if let title = viewModel.getTitle(note.text) {
                        HStack {
                            Text(title)
                                .lineLimit(1)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedNote = note
                        }
                    }
                }
                .onDelete(perform: viewModel.removeRows)
            }
            .task {
                viewModel.updateNotes()
            }
            
            Spacer()
            
            Button {
                showingAddNote.toggle()
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding()
            }
            .background(.white)
            .foregroundColor(.blue)
            .controlSize(.large)
            .cornerRadius(100/2)
            .padding()
            .sheet(isPresented: $showingAddNote) {
                AddNoteView(showingAddNote: $showingAddNote, notesViewModel: viewModel)
            }
            .sheet(isPresented: $showingEditNote) {
                if let selectedNote = selectedNote {
                    EditNoteView(showingEditNote: $showingEditNote, note: selectedNote, notesViewModel: viewModel)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
