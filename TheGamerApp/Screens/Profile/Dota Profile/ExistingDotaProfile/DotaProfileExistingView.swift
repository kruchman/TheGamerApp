//
//  DotaProfileExistingView.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 13/11/23.
//

import SwiftUI

struct DotaProfileExistingView: View {
    
    @StateObject private var viewModel = DotaProfileExistingViewModel()
    
    var body: some View {
            ZStack {
                GradientBackgroundView()
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    if let avatar = viewModel.avatar {
                        avatar.userAvatarModifier()
                    } else {
                        UserAvatarPlaceholder()
                    }
                    VStack(spacing: 20) {
                        HStack {
                            Text("Nickname:")
                                .font(.system(size: 21).weight(.light))
                                .foregroundColor(.white)
                            Text(viewModel.nicknameTitle)
                                .font(.system(size: 21).weight(.medium))
                                .foregroundColor(.white)
                        }
                        HStack {
                            Text("Rank:")
                                .font(.system(size: 21).weight(.light))
                                .foregroundColor(.white)
                            Text(viewModel.rankTitle)
                                .font(.system(size: 21).weight(.medium))
                                .foregroundColor(.white)
                        }
                        HStack {
                            Text("Position:")
                                .font(.system(size: 21).weight(.light))
                                .foregroundColor(.white)
                            Text(viewModel.position)
                                .font(.system(size: 21).weight(.medium))
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    
                    HStack {
                        if let favoriteHeroImages = viewModel.favoriteHeroImages {
                            favoriteHeroImages[0].favoriteHeroesModifier()
                            favoriteHeroImages[1].favoriteHeroesModifier()
                            favoriteHeroImages[2].favoriteHeroesModifier()
                        } else {
                            HeroPlaceholderImage()
                            HeroPlaceholderImage()
                            HeroPlaceholderImage()
                        }
                    }
                    
                    Button {
                        viewModel.deleteCurrentProfile()
                    } label: {
                        ZStack {
                            Color("GuestButtonColor")
                            HStack {
                                Text("Set Up")
                                    .font(.system(.title3, weight: .medium))
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                            .foregroundColor(.white)
                        }
                        .frame(width: 200, height: 60)
                        .cornerRadius(40)
                        .shadow(radius: 7)
                    }
                    .padding(.top, 100)

                    .alert(viewModel.alertMessage, isPresented: $viewModel.alertIsShown) {
                        
                    }
                }
                .navigationDestination(isPresented: $viewModel.shouldNavigateToProfileSetUp) {
                    MainView(selectedTab: .profile)
                }
                if
                    viewModel.dataAreLoading {
                    LoadingView()
                }
            }
    }
}



struct DotaProfileExistingView_Previews: PreviewProvider {
    static var previews: some View {
        DotaProfileExistingView()
    }
}
