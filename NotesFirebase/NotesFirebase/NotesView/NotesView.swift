//
//  NotesView.swift
//  NotesFirebase
//
//  Created by Erich Flock on 04.05.22.
//

import SwiftUI

struct NotesView: View {
    var body: some View {
        VStack {
            List {
                Text("Note 1")
                Text("Note 2")
                Text("Note 3")
                Text("Note 4")
            }
            
            Spacer()
            
            Button {
                print("did tap add")
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
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
