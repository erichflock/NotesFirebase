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
                VStack {
                    HStack {
                        if let imageURL = viewModel.getProfileImage()?.description {
                            AsyncImage(url: URL(string: imageURL))
                                .frame(width: 50, height: 50)
                                .cornerRadius(50/2)
                        }
                        
                        Text("Welcome \(viewModel.getUserName() ?? "")")
                        
                        Button {
                            viewModel.signOut()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .modifier(CloseButtonStyle(size: .regular))
                    }
                    .padding(.top, 10)
                    
                    NotesView()
                }
            }
            
            if !viewModel.isUserSignedIn() {
                Button {
                    viewModel.signIn()
                } label: {
                    Text("Sign In")
                    if viewModel.isLoading {
                        ProgressView()
                            .padding([.leading])
                    }
                }
                .modifier(StandardButtonStyle(size: .large))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
