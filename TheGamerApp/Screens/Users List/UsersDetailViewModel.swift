//
//  UsersDetailViewModel.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 26/11/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

final class UsersDetailViewModel: ObservableObject {
    
    @Published var alertMessage: String = ""
    @Published var alertIsShown = false
    @Published var shouldNavigateToChats = false
    
    func addToFavorites(userProfile: UserProfile) {
            guard let user = Auth.auth().currentUser else { return }
        let localUserProfile = UserProfile(id: userProfile.id,
                                           nickName: userProfile.nickName,
                                           rank: userProfile.rank,
                                           position: userProfile.position,
                                           favoriteHeroes: userProfile.favoriteHeroes,
                                           avatarPath: userProfile.avatarPath)
            Firestore.firestore().collection("Users").whereField("id", isEqualTo: user.uid).getDocuments { (querySnapshot, error) in
                guard error == nil else {
                    print("Error getting user document: \(error!.localizedDescription)")
                    return
                }
                guard let documents = querySnapshot?.documents, let userDocument = documents.first else {
                    print("User document not found")
                    return
                }
                let favoritesCollection = userDocument.reference.collection("Favorite User Dota Profiles")
                do {
                    try favoritesCollection.addDocument(from: localUserProfile)
                } catch {
                    print("Error adding favorite profile: \(error.localizedDescription)")
                }
            }
        }
    
}
