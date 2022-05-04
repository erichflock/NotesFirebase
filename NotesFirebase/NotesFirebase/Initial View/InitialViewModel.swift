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
    
    let clientID = "640274747024-i161pqk865674m0ej0saav67cvalegvn.apps.googleusercontent.com"
    @Published var isLoading = false
    
    func isUserSignedIn() -> Bool {
        FirebaseAuth.Auth.auth().currentUser != nil && GIDSignIn.sharedInstance.currentUser != nil
    }
    
    func signIn(){
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
        
        isLoading = true
        
        let signInConfig = GIDConfiguration.init(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: presentingViewController,
            callback: { user, error in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                    self.isLoading = false
                }
                
                guard let auth = user?.authentication, let idToken = auth.idToken else {
                    print("SignIn Error: No authentication data available")
                    self.isLoading = false
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: auth.accessToken)
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    
                    self.isLoading = false
                }
    
            }
        )
    }
    
    func signOut() {
        do {
            GIDSignIn.sharedInstance.signOut()
            try Auth.auth().signOut()
            self.objectWillChange.send()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func getUserName() -> String? {
        GIDSignIn.sharedInstance.currentUser?.profile?.name
    }
    
    func getProfileImage() -> URL? {
        GIDSignIn.sharedInstance.currentUser?.profile?.imageURL(withDimension: 50)
    }
    
}
