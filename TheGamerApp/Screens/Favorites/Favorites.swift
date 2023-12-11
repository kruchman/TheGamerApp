//
//  Favorites.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 6/11/23.
//

import SwiftUI

struct Favorites: View {
    
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    ForEach(viewModel.userProfiles) { userProfile in
                        GamerCell(userProfile: userProfile)
                            .onTapGesture {
                                viewModel.selectedProfile = userProfile
                                viewModel.isShowingDetail = true
                            }
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.isShowingDetail) {
                FavoritesDetailView(viewModel: viewModel,
                                    userProfile: viewModel.selectedProfile ?? UserProfile.sample)
            }
            if viewModel.usersAreLoading {
                LoadingView()
            }
        }
    }
}

struct Favorites_Previews: PreviewProvider {
    static var previews: some View {
        Favorites()
    }
}
