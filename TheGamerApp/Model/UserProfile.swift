//
//  UserModel.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 5/11/23.
//

import SwiftUI

struct UserProfile: Codable, Identifiable {

    let id: String
    var nickName: String = ""
    var rank: String = ""
    var position: String = ""
    var favoriteHeroes: [String] = []
    var avatarPath: String = ""
    
    var avatarData: Data?
    var avatarImage: Image? {
        if let avatarData = avatarData {
            if let uiImage = UIImage(data: avatarData) {
                let image = Image(uiImage: uiImage)
                return image
            }
        }
        return nil
    }
    
    var firstFavoriteHeroData: Data?
    var firstFavoriteHeroImage: Image? {
        if let firstHero = firstFavoriteHeroData {
            if let uiImage = UIImage(data: firstHero) {
                let image = Image(uiImage: uiImage)
                return image
            }
        }
        return nil
    }
    var secondFavoriteHeroData: Data?
    var secondFavoriteHeroImage: Image? {
        if let secondHero = secondFavoriteHeroData {
            if let uiImage = UIImage(data: secondHero) {
                let image = Image(uiImage: uiImage)
                return image
            }
        }
        return nil
    }
    var thirdFavoriteHeroData: Data?
    var thirdFavoriteHeroImage: Image? {
        if let thirdHero = thirdFavoriteHeroData {
            if let uiImage = UIImage(data: thirdHero) {
                let image = Image(uiImage: uiImage)
                return image
            }
        }
        return nil
    }
    
    static let sample = UserProfile(id: UUID().uuidString,
                                                 nickName: "Dendi",
                                                 rank: "7500",
                                                 position: "midlaner",
                                                 favoriteHeroes: ["Pudge", "Invoker", "Storm Spirit"])
    static let sampleTwo = UserProfile(id: UUID().uuidString,
                                        nickName: "Artizi",
                                        rank: "7700",
                                        position: "carry",
                                        favoriteHeroes: ["Terrorblade", "Alchemist", "Phantom Assasin"])
}


