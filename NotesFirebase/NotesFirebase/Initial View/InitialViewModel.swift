//
//  InitialViewModel.swift
//  NotesFirebase
//
//  Created by Erich Flock on 04.05.22.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

class InitialViewModel: ObservableObject {
    
    @Published var isLoading = false
    
    func signIn() {
        isLoading = true
        
        NetworkManager.shared.signIn() { [weak self] success in
            self?.isLoading = false
            
            guard success else {
                print("Sign in error")
                return
            }
            
            self?.objectWillChange.send()
        }
    }
    
    func signOut() {
        NetworkManager.shared.signOut() { success in
            self.objectWillChange.send()
        }
    }
    
    func isUserSignedIn() -> Bool {
        NetworkManager.shared.isUserSignedIn()
    }
    
    func getUserName() -> String? {
        NetworkManager.shared.user?.name
    }
    
    func getProfileImage() -> URL? {
        NetworkManager.shared.user?.profileImage
    }
    
}

struct User: Codable {
    var uid: String
    var name: String?
    var profileImage: URL?
}
