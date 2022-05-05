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
    
    private var user: User? {
        get {
            if let data = UserDefaults.standard.value(forKey: "user") as? Data {
                let user = try? PropertyListDecoder().decode(User.self, from: data)
                return user
            } else {
                return nil
            }
        }

        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "user")
        }
    }
    
    func isUserSignedIn() -> Bool {
        user != nil
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
                    
                    self.save(user: user, uid: authResult?.user.uid)
                    self.isLoading = false
                }
            }
        )
    }
    
    func signOut() {
        do {
            removeUser()
            GIDSignIn.sharedInstance.signOut()
            try Auth.auth().signOut()
            self.objectWillChange.send()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func getUserName() -> String? {
        user?.name
    }
    
    func getProfileImage() -> URL? {
        user?.profileImage
    }
    
    private func save(user: GIDGoogleUser?, uid: String?) {
        guard let user = user, let uid = uid else { return }
        
        self.user = User(uid: uid, name: user.profile?.name, profileImage: user.profile?.imageURL(withDimension: 50))
    }
    
    private func removeUser() {
        UserDefaults.standard.set(nil, forKey: "user")
    }
    
}

struct User: Codable {
    var uid: String
    var name: String?
    var profileImage: URL?
}
