//
//  EnterViewModel.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 3/11/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

final class EnterViewModel: ObservableObject {
    
    @AppStorage("user") var user: Data?
    
    init() {
        guard let userData = user else { return }
        do {
            let decodedUserData = try JSONDecoder().decode(User.self, from: userData)
            isUserLoggedIn = decodedUserData.isLoggedIn
        } catch {
            print("Error decoding Data from App Storage while initializing")
        }
    }
    
    @Published var email = ""
    @Published var password = ""
    
    @Published var isValidEmail = false
    @Published var isValidPassword = false
    
    @Published var isUserLoggedIn = false
    @Published var isGuestLoggedIn = false
    
    @Published var errorMessage: String = ""
    @Published var alertIsShown = false
    
    var loginPrompt: String? {
        if email.isEmpty || email.isValidEmail {
            return nil
        } else {
          return  "Enter the correct email please. Example: gamer@gmail.com"
        }
    }
    
    var passwordPrompt: String? {
        if password.isEmpty || password.isValidPassword {
            return nil
        } else {
            return "Your password must contain at least one capital letter, at least one number and be at least 8 characters long"
        }
    }
    
    func logIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                self.errorMessage = "Invalid Login or Password"
                self.alertIsShown.toggle()
            }
            if let result = result {
                self.isUserLoggedIn = true

                User.shared.isOnline = true
                User.shared.isLoggedIn = true
                do {
                    let encodedUserData = try JSONEncoder().encode(User.shared)
                    self.user = encodedUserData
                } catch {
                    print("Error while encoding the user data to AppStorage")
                }
            }
        }
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                self.errorMessage = "Invalid Login or Password"
                self.alertIsShown.toggle()
            }
            if let result = result {
                self.isUserLoggedIn = true
        
                User.shared.isOnline = true
                User.shared.isLoggedIn = true
                do {
                    let encodedUserData = try JSONEncoder().encode(User.shared)
                    self.user = encodedUserData
                    Firestore.firestore().collection("Users").addDocument(data: ["id" : Auth.auth().currentUser?.uid ?? "",
                                                                                                   "hasDotaProfile" : false])
                } catch {
                    print("Error while encoding the user data to AppStorage")
                }
            }
        }
    }

}
