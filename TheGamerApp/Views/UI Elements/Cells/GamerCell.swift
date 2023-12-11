//
//  GamerCell.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 24/11/23.
//

import SwiftUI
import FirebaseStorage

struct GamerCell: View {
    
    var userProfile: UserProfile

    var body: some View {
        
        VStack {
            HStack {
                if let avatar = userProfile.avatarImage {
                    avatar
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 110, height: 110)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                } else {
                    Image("avatar placeholder")
                        .resizable()
                        .frame(width: 110, height: 110)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                
                VStack(alignment:.leading) {
                    HStack {
                        Text("Nickname: ")
                            .font(.callout)
                            .foregroundColor(.white)
                        Text(userProfile.nickName)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    HStack {
                        Text("Rank: ")
                            .font(.callout)
                            .foregroundColor(.white)
                        Text(userProfile.rank)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    HStack {
                        Text("Position: ")
                            .font(.callout)
                            .foregroundColor(.white)
                        Text(userProfile.position)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    HStack {
                        if let firstHero = userProfile.firstFavoriteHeroImage {
                            firstHero
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 10)
                        } else {
                            Image("Hero Placeholder")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 10)
                        }
                        if let secondHero = userProfile.secondFavoriteHeroImage {
                            secondHero
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 10)
                        } else {
                            Image("Hero Placeholder")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 10)
                        }
                        if let thirdHero = userProfile.thirdFavoriteHeroImage {
                            thirdHero
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 10)
                        } else {
                            Image("Hero Placeholder")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 10)
                        }
                    }
                    
                }
                .padding(.leading)
                Spacer()
            }
            .frame(maxWidth: 400)
            .padding()
            
        }
        .background(GradientBackgroundView())
        .cornerRadius(50)
        .shadow(radius: 10)
    }
}

struct GamerCell_Previews: PreviewProvider {
    static var previews: some View {
        GamerCell(userProfile: UserProfile.sample)
    }
}

