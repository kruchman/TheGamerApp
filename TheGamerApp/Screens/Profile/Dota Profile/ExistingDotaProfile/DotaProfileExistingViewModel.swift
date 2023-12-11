//
//  DotaProfileExistingViewModel.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 13/11/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

@MainActor final class DotaProfileExistingViewModel: ObservableObject {
    
    @AppStorage("user") var user: Data?
    @AppStorage("user profile")  var userProfileData: Data?
    
    var userProfile: UserProfile?
    
    @Published var avatar: Image?
    @Published var nicknameTitle = ""
    @Published var rankTitle = ""
    @Published var position = ""
    @Published var favoriteHeroImages: [Image]?
    @Published var dataAreLoading = false
    @Published var alertMessage: String = ""
    @Published var alertIsShown = false
    @Published var shouldNavigateToProfileSetUp = false
    
    var favoriteHeroes = [String]()
    var avatarPath = ""
    
    init() {
        self.dataAreLoading = true 
        guard let user = user, let userProfileData =  userProfileData else { return }
        do {
            User.shared = try JSONDecoder().decode(User.self, from: user)
            try DataManager.shared.fetchDotaProfileData(completion: { userProfile in
                if let userProfile = userProfile {
                    self.dataAreLoading = true
                    self.nicknameTitle = userProfile.nickName
                    self.rankTitle = userProfile.rank
                    self.position = userProfile.position
                    self.favoriteHeroes = userProfile.favoriteHeroes
                    self.avatarPath = userProfile.avatarPath
                    
                    self.fetchAvatar()
                    self.fetchHeroImages()
                }
            })
        } catch {
            alertMessage = "Oops, somethig went wrong..."
            alertIsShown.toggle()
        }
    }
    
    func fetchHeroImages() {
        Task {
            var heroes = [Image]()
            do {
                for hero in favoriteHeroes {
                    let data = try await StorageManager.shared.getData(heroName: hero + ".png")
                    if let uiImage = UIImage(data: data) {
                        let image = Image(uiImage: uiImage)
                        heroes.append(image)
                    }
                }
                favoriteHeroImages = heroes
                dataAreLoading = false
            } catch {
                alertMessage = "Internet connection problems"
                alertIsShown.toggle()
                print("Error fetching Images of Heroes")
                dataAreLoading = false
            }
        }
    }
    
    
    func fetchAvatar() {
        Task {
            do {
                let data = try await StorageManager.shared.fetchUserPhoto(userPhotoPath: avatarPath)
                if let uiImage = UIImage(data: data) {
                    self.avatar = Image(uiImage: uiImage)
                }
            } catch {
                alertMessage = "Internet connection problems"
                alertIsShown.toggle()
                print("Error fetching Avatar")
            }
        }
    }
    
    
    //MARK: - Delete Methods
    
    func deleteCurrentProfile() {
        DataManager.shared.deleteCurrentProfile(avatarPath: avatarPath) { result in
            switch result {
            case .success(let userProfile):
                self.userProfile = userProfile
                User.shared.hasDotaProfile = false
                do {
                    let encodedUserData = try JSONEncoder().encode(User.shared)
                    self.user = encodedUserData
                } catch {
                    print("Error encoding Uers Data")
                }
                self.shouldNavigateToProfileSetUp.toggle()
            case .failure(_):
                self.alertMessage = "Could not delete your profile, something went wrong..."
                self.alertIsShown.toggle()
            }
        }
    }
    
}
