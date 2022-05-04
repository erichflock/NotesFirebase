//
//  ContentView.swift
//  NotesFirebase
//
//  Created by Erich Flock on 04.05.22.
//

import SwiftUI

struct InitialView: View {
    
    @StateObject var viewModel = InitialViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            
            if viewModel.isUserSignedIn() {
                
                if let imageURL = viewModel.getProfileImage()?.description {
                    AsyncImage(url: URL(string: imageURL))
                        .frame(width: 50, height: 50)
                        .cornerRadius(50/2)
                }
                
                Text("Welcome \(viewModel.getUserName() ?? "")")
                
                Button {
                    viewModel.signOut()
                } label: {
                    Text("Sign Out")
                }
                .modifier(StandardButtonStyle())
            }
            
            if !viewModel.isUserSignedIn() {
                Button {
                    viewModel.signIn()
                } label: {
                    Text("Sign In")
                }
                .modifier(StandardButtonStyle())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
