//
//  FavoritesViewModel.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 26/11/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

@MainActor final class FavoritesViewModel: ObservableObject {
    
    @Published var userProfiles: [UserProfile] = []
    @Published var usersAreLoading = false
    @Published var selectedProfile: UserProfile?
    @Published var isShowingDetail = false
    @Published var shouldNavigateToChats = false 
    @Published var shouldNavigateToMain = false
    @Published var alertIsShown = false
    @Published var alertMessage = ""
    
    init() {
        fetchFavorites()
    }

    func fetchFavorites() {
        guard let user = Auth.auth().currentUser else { return }
        usersAreLoading = true
        Firestore.firestore().collection("Users").whereField("id", isEqualTo: user.uid).addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error getting user document: \(error!.localizedDescription)")
                return
            }
            guard let documents = querySnapshot?.documents, let userDocument = documents.first else {
                print("User document not found")
                return
            }
            let favoritesCollection = userDocument.reference.collection("Favorite User Dota Profiles")
            
            favoritesCollection.getDocuments { (querySnapshot, error) in
                guard error == nil else {
                    print("Error getting user document: \(error!.localizedDescription)")
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    print("User document not found")
                    return
                }
                var userProfiles = [UserProfile]()
                for document in documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let avatarPath = data["avatarPath"] as? String ?? ""
                    let nickName = data["nickName"] as? String ?? ""
                    let rank = data["rank"] as? String ?? ""
                    let position = data["position"] as? String ?? ""
                    let favoriteHeroes = data["favoriteHeroes"] as? [String] ?? [String]()
                    
                    var userProfile = UserProfile(id: id,
                                                  nickName: nickName,
                                                  rank: rank,
                                                  position: position,
                                                  favoriteHeroes: favoriteHeroes,
                                                  avatarPath: avatarPath)
                    
                    Task {
                        userProfile.avatarData = try await StorageManager.shared.fetchUserPhoto(userPhotoPath: avatarPath)
                        userProfile.firstFavoriteHeroData = try await StorageManager.shared.getData(heroName: userProfile.favoriteHeroes[0] + ".png")
                        userProfile.secondFavoriteHeroData = try await StorageManager.shared.getData(heroName: userProfile.favoriteHeroes[1] + ".png")
                        userProfile.thirdFavoriteHeroData = try await StorageManager.shared.getData(heroName: userProfile.favoriteHeroes[2] + ".png")
                        
                        userProfiles.append(userProfile)
                        self.userProfiles = userProfiles
                    }
                }
                self.usersAreLoading = false
            }
        }
    }
    
    func deleteFromFavorites(userProfileNickName: String) {
        guard let user = Auth.auth().currentUser else { return }
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
            favoritesCollection.whereField("nickName", isEqualTo: userProfileNickName).getDocuments { (querySnapshot, error) in
                guard error == nil else {
                    print("Error getting favorite profile document: \(error!.localizedDescription)")
                    return
                }
                guard let documents = querySnapshot?.documents, let favoriteProfileDocument = documents.first else {
                    print("Favorite profile document not found")
                    return
                }
                favoriteProfileDocument.reference.delete { error in
                    if let error = error {
                        print("Error deleting favorite profile document: \(error.localizedDescription)")
                    } else {
                        print("Favorite profile document deleted successfully")
                        self.alertMessage = "Successfully deleted from favorites"
                        self.alertIsShown.toggle()
                    }
                }
            }
        }
    }

    
}
