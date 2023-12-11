//
//  GamersList.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 6/11/23.
//

import SwiftUI

struct UsersList: View {
    
    @StateObject private var viewModel = UsersListViewModel()
    
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
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $viewModel.isShowingDetail) {
                UsersDetailView(userProfile: viewModel.selectedProfile ?? UserProfile.sample)
            }

            if viewModel.usersAreLoading {
                LoadingView()
            }
        }
    }
}

struct UsersList_Previews: PreviewProvider {
    static var previews: some View {
        UsersList()
    }
}
