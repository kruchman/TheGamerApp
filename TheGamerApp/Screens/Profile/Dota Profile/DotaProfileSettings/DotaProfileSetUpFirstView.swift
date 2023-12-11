//
//  DotaCell.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 8/11/23.
//

import SwiftUI
import PhotosUI

struct DotaProfileSetUpFirstView: View {
    
    @StateObject private var viewModel = DotaProfileSetUpViewModel()
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 40) {
                    
                    if let userAvatar = viewModel.userAvatar {
                        Image(uiImage: userAvatar)
                            .userAvatarModifier()
                    } else {
                        UserAvatarPlaceholder()
                    }
                    
                    PhotosPicker(selection: $viewModel.selectedItem,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Text("Add your foto")
                            .font(.system(size: 25).weight(.light))
                            .foregroundColor(.white)
                    }
                    
                    VStack {
                        Text("Write your nickname")
                            .font(.system(size: 21).weight(.light))
                            .foregroundColor(.white)
                        
                        CustomTextField(title: "Nickname", text: $viewModel.nicknameTitle)
                    }
                    .padding()
                    
                    VStack {
                        Text("Write your rank")
                            .font(.system(size: 21).weight(.light))
                            .foregroundColor(.white)
                        
                        CustomTextField(title: "Rank", text: $viewModel.rankTitle)
                    }
                    .padding()
                }
                .onChange(of: viewModel.selectedItem) { newValue in
                    if let newValue {
                        viewModel.saveProfileImage(item: newValue)
                    }
                }
                .onChange(of: viewModel.nicknameTitle) { newValue in
                    viewModel.nicknameTitle = newValue
                }
                .onChange(of: viewModel.rankTitle) { newValue in
                    viewModel.rankTitle = newValue
                }
                    DotaProfileSetUpSecondView(viewModel: viewModel)

                        .alert(viewModel.alertMessage, isPresented: $viewModel.alertIsShown) {
                            
                        }
                }
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        VStack {
                            Image(systemName: "gobackward")
                            Text("Reset")
                                .font(.headline)
                        }
                        .frame(width: 65, height: 65)
                        .onTapGesture {
                            viewModel.refreshAll()
                        }
                    }
            }
        }
    }
}
    


struct DotaProfileSetUpFirstView_Previews: PreviewProvider {
    static var previews: some View {
        DotaProfileSetUpFirstView()
    }
}
