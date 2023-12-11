//
//  DotaProfileViewModel.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 8/11/23.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore

final class DotaProfileSetUpViewModel: ObservableObject {
    
    @AppStorage("user") var user: Data?
    
    var userProfile: UserProfile?
    var userFavoriteHeroes = [String]()
    var userAvatarPath: String?
    var positions = ["carry", "midlaner", "offlaner", "semi support", "full support"]
    var fieldsFilled: Bool {
        let userFavoriteHeroesSet = Set(userFavoriteHeroes)
        if !nicknameTitle.isEmpty &&
            !rankTitle.isEmpty &&
            !userFavoriteHeroes.isEmpty &&
            userFavoriteHeroes.count == 3 &&
            userFavoriteHeroes.count == userFavoriteHeroesSet.count {
            return true
        } else {
            return false
        }
    }
    
    @Published var userHasProfile = false
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var userAvatar: UIImage? = nil
    @Published var nicknameTitle = ""
    @Published var rankTitle = ""
    @Published var selectionPositionIndex = 0
    @Published var selectedHeroIndex = 0
    @Published var dotaHeroesNames = [String]()
    @Published var firstFavoriteHeroData: Data? = nil
    @Published var secondFavoriteHeroData: Data? = nil
    @Published var thirdFavoriteHeroData: Data? = nil
    @Published var prompt: String?
    @Published var alertMessage: String = ""
    @Published var alertIsShown = false 
    @Published var shouldNavigateToProfileMainView = false
    
    //MARK: - Fetching Heroes Methods
    
    @MainActor
    func fetchHeroesNames() {
        Task {
            do {
                try await fetchHeroes()
                dotaHeroesNames = dotaHeroesNames.sorted()
            } catch {
                alertMessage = "Internet connection problems"
                alertIsShown.toggle()
                throw ErrorManager.invalidData
            }
        }
    }
    
    @MainActor
    func fetchHeroes() async throws {
        guard let url = URL(string: "https://api.opendota.com/api/heroes") else {
            alertMessage = "Internet connection problems"
            alertIsShown.toggle()
            throw ErrorManager.badURL
        }
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ErrorManager.invalidResponse
        }
        do {
           let heroes = try parseJSON(data: data)
            for hero in heroes {
                dotaHeroesNames.append(hero.localized_name)
            }
        } catch {
            throw ErrorManager.invalidData
        }
    }
    
    private func parseJSON(data: Data) throws -> DotaHeroes {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(DotaHeroes.self, from: data)
            return decodedData
        } catch {
            throw ErrorManager.invalidData
        }
    }
    
    @MainActor
    func fetchFavoriteHeroImages() {
        Task {
                if firstFavoriteHeroData == nil {
                    firstFavoriteHeroData = try await StorageManager.shared.getData(heroName: dotaHeroesNames[selectedHeroIndex] + ".png")
                    userFavoriteHeroes.append(dotaHeroesNames[selectedHeroIndex])
                } else if firstFavoriteHeroData != nil && secondFavoriteHeroData == nil {
                    secondFavoriteHeroData = try await StorageManager.shared.getData(heroName: dotaHeroesNames[selectedHeroIndex] + ".png")
                    userFavoriteHeroes.append(dotaHeroesNames[selectedHeroIndex])
                } else if firstFavoriteHeroData != nil && secondFavoriteHeroData != nil && thirdFavoriteHeroData == nil {
                    thirdFavoriteHeroData = try await StorageManager.shared.getData(heroName: dotaHeroesNames[selectedHeroIndex] + ".png")
                    userFavoriteHeroes.append(dotaHeroesNames[selectedHeroIndex])
                } else {
                    refresh()
                }
            }
        }
    
    //MARK: - Refresh Data Methods
    func refresh() {
        firstFavoriteHeroData = nil
        secondFavoriteHeroData = nil
        thirdFavoriteHeroData = nil
        userFavoriteHeroes = []
    }

    func refreshAll() {
        userAvatar = nil
        nicknameTitle = ""
        rankTitle = ""
        selectionPositionIndex = 0
        firstFavoriteHeroData = nil
        secondFavoriteHeroData = nil
        thirdFavoriteHeroData = nil
        userFavoriteHeroes = []
    }

       //MARK: - Saving Profile Methods
    
    @MainActor
    func checkFields() {
        let userFavoriteHeroesSet = Set(userFavoriteHeroes)
        if nicknameTitle.isEmpty ||
           rankTitle.isEmpty ||
           userFavoriteHeroes.isEmpty ||
            userFavoriteHeroes.count != userFavoriteHeroesSet.count {
            prompt = "Please fill all the fields, and choose three different heroes"
        } else {
            saveUserProfile()
        }
    }
    
    @MainActor
    func saveProfileImage(item: PhotosPickerItem) {
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else {
                alertMessage = "Photo processing error"
                alertIsShown.toggle()
                throw ErrorManager.transferDataError
            }
            let (path, name) = try await StorageManager.shared.saveImage(data: data)
            userAvatarPath = name
            userAvatar = UIImage(data: data)
        }
    }
    
    func saveUserProfile() {
        DataManager.shared.saveUserProfile(nickName: nicknameTitle, rank: rankTitle, position: positions[selectionPositionIndex], favoriteHeroes: userFavoriteHeroes, avatarPath: userAvatarPath ?? "") { result in
            switch result {
            case .success(_):
                User.shared.hasDotaProfile = true
                do {
                    let encodedUserData = try JSONEncoder().encode(User.shared)
                    self.user = encodedUserData
                } catch {
                    print("Error encoding user data.")
                }
                print("User profile saved successfully.")
                self.shouldNavigateToProfileMainView.toggle()
            case .failure(_):
                self.alertMessage = "Could not save your profile, something went wrong..."
                self.alertIsShown.toggle()
            }
        }
    }
    
}

