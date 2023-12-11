//
//  GamerListViewModel.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 24/11/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

@MainActor final class UsersListViewModel: ObservableObject {
    
    @Published var userProfiles: [UserProfile] = []
    @Published var usersAreLoading = false
    @Published var selectedProfile: UserProfile?
    @Published var isShowingDetail = false
    
    init() {
        fetchUserProfiles()
    }

    func fetchUserProfiles() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        usersAreLoading = true
        DataManager.shared.userDotaProfiles.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                var userProfiles = [UserProfile]()
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let avatarPath = data["avatarPath"] as? String ?? ""
                    let nickName = data["nickName"] as? String ?? ""
                    let rank = data["rank"] as? String ?? ""
                    let position = data["position"] as? String ?? ""
                    let favoriteHeroes = data["favoriteHeroes"] as? [String] ?? [String]()
                    
                    if id == currentUser.uid {
                        continue
                    }
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
                        self.userProfiles = userProfiles.sorted(by: { $0.rank > $1.rank})
                        self.usersAreLoading = false
                    }
                }
            }
        }
    }
    
}
