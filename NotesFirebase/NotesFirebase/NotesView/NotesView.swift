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
    
    var body: some View {
        VStack {
            List() {
                ForEach(viewModel.notes) { note in
                    if let title = viewModel.getTitle(note.text) {
                        HStack {
                            Text(title)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showingEditNote.toggle()
                        }
                        .sheet(isPresented: $showingEditNote) {
                            EditNoteView(showingEditNote: $showingEditNote, note: note, notesViewModel: viewModel)
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
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
