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
    
    var body: some View {
        VStack {
            List() {
                ForEach(viewModel.notes, id: \.self) { note in
                    if let title = viewModel.getTitle(note) {
                        Text(title)
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
                AddNoteView(showingAddNote: $showingAddNote, notes: $viewModel.notes)
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
