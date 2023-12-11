//
//  GamerDetailView.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 26/11/23.
//

import SwiftUI

struct UsersDetailView: View {
    
    @StateObject private var viewModel = UsersDetailViewModel()
    
    var userProfile: UserProfile
    
    var body: some View {
        
        ZStack {
            GradientBackgroundView()
                .ignoresSafeArea()
            VStack(spacing: 20) {
                
                Spacer()
                
                if let avatar = userProfile.avatarImage {
                    avatar
                        .userAvatarModifier()
                } else {
                    UserAvatarPlaceholder()
                }
                
                VStack(spacing: 20) {
                    HStack {
                        Text("Nickname:")
                            .font(.system(size: 21).weight(.light))
                            .foregroundColor(.white)
                        Text(userProfile.nickName)
                            .font(.system(size: 21).weight(.medium))
                            .foregroundColor(.white)
                    }
                    HStack {
                        Text("Rank:")
                            .font(.system(size: 21).weight(.light))
                            .foregroundColor(.white)
                        Text(userProfile.rank)
                            .font(.system(size: 21).weight(.medium))
                            .foregroundColor(.white)
                    }
                    HStack {
                        Text("Position:")
                            .font(.system(size: 21).weight(.light))
                            .foregroundColor(.white)
                        Text(userProfile.position)
                            .font(.system(size: 21).weight(.medium))
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                HStack {
                    if let firstHero = userProfile.firstFavoriteHeroImage {
                        firstHero
                            .favoriteHeroesModifier()
                    } else {
                        HeroPlaceholderImage()
                    }
                    if let secondHero = userProfile.secondFavoriteHeroImage {
                        secondHero.favoriteHeroesModifier()
                    } else {
                        HeroPlaceholderImage()
                    }
                    if let thirdHero = userProfile.thirdFavoriteHeroImage {
                        thirdHero.favoriteHeroesModifier()
                    } else {
                        HeroPlaceholderImage()
                    }
                    
                }
                
                Spacer()
                
                HStack(spacing: 50) {
                    Button {
                        DataManager.shared.checkForChatExistence(anotherUserProfile: userProfile) { chat in
                            if chat != nil {
                                viewModel.alertMessage = "Chat already exists"
                                viewModel.alertIsShown.toggle()
                            } else {
                                do {
                                    try DataManager.shared.createNewChat(anotherUserProfile: userProfile, completion: { _ in
                                        viewModel.shouldNavigateToChats.toggle()
                                    })
                                } catch {
                                    print("Error while trying to create new Chat")
                                }
                            }
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color("GuestButtonColor"))
                                .shadow(radius: 10)
                            
                            Image(systemName: "ellipsis.message")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                    }
                    
                    Button {
                        print("Add to Favorites")
                        viewModel.addToFavorites(userProfile: userProfile)
                        viewModel.alertMessage = "Successfully added to favorites"
                        viewModel.alertIsShown.toggle()
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color("GuestButtonColor"))
                                .shadow(radius: 10)
                            
                            Image(systemName: "bolt.heart")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                    }

                }
                .padding(.bottom, 50)
                
                .alert(viewModel.alertMessage, isPresented: $viewModel.alertIsShown) {
                    
                }
            }
            .navigationDestination(isPresented: $viewModel.shouldNavigateToChats) {
                MainView(selectedTab: .chats)
        }
            
        }
    }
}

struct UsersDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UsersDetailView(userProfile: UserProfile.sample)
    }
}
