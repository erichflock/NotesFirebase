//
//  NotesView.swift
//  NotesFirebase
//
//  Created by Erich Flock on 04.05.22.
//

import SwiftUI

struct NotesView: View {
    var body: some View {
        List {
            Text("Note 1")
            Text("Note 2")
            Text("Note 3")
            Text("Note 4")
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
