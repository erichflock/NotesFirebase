//
//  NetworkManager.swift
//  NotesFirebase
//
//  Created by Erich Flock on 06.05.22.
//

import Firebase
import FirebaseDatabase
import FirebaseAuth
import GoogleSignIn

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let databaseReference = Database.database().reference()
    
    @Published var isLoading = false
    
    var user: User? {
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
    
    private init() {}
}

//MARK: Authentication
extension NetworkManager {
    
    func isUserSignedIn() -> Bool {
        user != nil
    }
    
    func signIn(completion: @escaping (Bool) -> ()) {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            completion(false)
            return
        }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let signInConfig = GIDConfiguration.init(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: presentingViewController,
            callback: { user, error in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                    completion(false)
                }
                
                guard let auth = user?.authentication, let idToken = auth.idToken else {
                    print("SignIn Error: No authentication data available")
                    completion(false)
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: auth.accessToken)
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        completion(false)
                    }
                    
                    self.save(user: user, uid: authResult?.user.uid)
                    completion(true)
                }
            }
        )
    }
    
    func signOut(completion: @escaping (Bool) -> ()) {
        do {
            removeUser()
            GIDSignIn.sharedInstance.signOut()
            try Auth.auth().signOut()
            completion(true)
        } catch {
            print("error: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    private func save(user: GIDGoogleUser?, uid: String?) {
        guard let user = user, let uid = uid else { return }
        
        self.user = User(uid: uid, name: user.profile?.name, profileImage: user.profile?.imageURL(withDimension: 50))
    }
    
    private func removeUser() {
        UserDefaults.standard.set(nil, forKey: "user")
    }
    
}

//MARK: Database
extension NetworkManager {
    
    func getNotes(completion: @escaping ([Note]) -> ()) {
        guard let databaseReference = createDatabaseReference() else { return }
        
        let query = databaseReference.queryOrdered(byChild: "/date")
        
        query.observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { snapshot, key in
            
            let dispatchGroup = DispatchGroup()
            let children = snapshot.children
            
            dispatchGroup.enter()
            
            var notes: [Note] = []
            
            for child in children {
                let childSnapshot = child as? DataSnapshot
                guard let childNote = childSnapshot?.value as? NSDictionary else { return }
                
                if let key = childSnapshot?.key, let noteText = childNote.value(forKey: "note") as? String {
                    let note = Note(key: key, text: noteText)
                    notes.append(note)
                }
            }
            
            dispatchGroup.leave()
            dispatchGroup.notify(queue: .main) {
                completion(notes)
            }
        })
    }
    
    func deleteNote(noteKey: String, completion: @escaping (Bool) -> ()) {
        guard let databaseReferece = createDatabaseReference() else {
            completion(false)
            return
        }
        
        databaseReferece.observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { snapshot, key in
            
            let dispatchGroup = DispatchGroup()
            let children = snapshot.children
            
            dispatchGroup.enter()
            
            for child in children {
                let childSnapshot = child as? DataSnapshot
                guard let key = childSnapshot?.key else {
                    completion(false)
                    return
                }
                
                if noteKey == key {
                    databaseReferece.child(noteKey).removeValue()
                }
            }
            
            dispatchGroup.leave()
            dispatchGroup.notify(queue: .main) {
                completion(true)
            }
        })
    }
    
    func saveNote(text: String, completion: @escaping (Bool) -> ()) {
        guard let userID = user?.uid else {
            print("error: user id not available.")
            completion(false)
            return
        }
        
        let databaseReference = Database.database().reference()
        
        guard let key = databaseReference.child(userID).child("posts").childByAutoId().key else {
            print("error: error while creating key")
            completion(false)
            return
        }
        
        guard let userName = user?.name else {
            completion(false)
            return
        }
        
        let post = ["date": Date().formatted(date: .abbreviated, time: .standard),
                    "userUid": userID,
                    "userName": userName,
                    "note": text]
        
        let childUpdates = ["/users/\(userID)/notes/\(key)": post]
        
        databaseReference.updateChildValues(childUpdates)
        
        completion(true)
    }
    
    func update(note: Note, newText: String, completion: @escaping (Bool) -> ()) {
        guard let databaseReferece = createDatabaseReference() else {
            completion(false)
            return
        }
        
        databaseReferece.observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { snapshot, key in
            let dispatchGroup = DispatchGroup()
            let children = snapshot.children
            
            dispatchGroup.enter()
            
            for child in children {
                let childSnapshot = child as? DataSnapshot
                guard let key = childSnapshot?.key else {
                    completion(false)
                    return
                }
                
                if note.key == key {
                    databaseReferece.child(key).child("note").setValue(newText)
                }
            }
            
            dispatchGroup.leave()
            dispatchGroup.notify(queue: .main) {
                completion(true)
            }
        })
    }
    
    //Helper Functions
    private func createDatabaseReference() -> DatabaseReference? {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("error: user id not available. Please, sign in again.")
            return nil
        }
        
        return databaseReference.child("users").child(userID).child("notes")
    }
    
}
