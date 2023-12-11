//
//  DotaProfileSecondView.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 9/11/23.
//

import SwiftUI

struct DotaProfileSetUpSecondView: View {
    
    @ObservedObject var viewModel: DotaProfileSetUpViewModel
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
                .ignoresSafeArea()
            VStack {
                VStack {
                    Text("Choose your position")
                        .font(.system(size: 21).weight(.light))
                        .foregroundColor(.white)
                    
                    Picker(selection: $viewModel.selectionPositionIndex) {
                        ForEach(viewModel.positions.indices, id: \.self) { index in
                            Text(viewModel.positions[index])
                                .foregroundColor(.white)
                        }
                    } label: {
                        Text("Position")
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 250, height: 150)

                }
                .padding()
                
                VStack {
                    Text("Choose your favorite heroes")
                        .font(.system(size: 21).weight(.light))
                        .foregroundColor(.white)
                        .padding(.bottom, 30)
                
                        HStack {
                        
                            if let imageData = viewModel.firstFavoriteHeroData, let image = UIImage(data: imageData) {
                                Image(uiImage: image).favoriteHeroesModifier()
                            } else {
                                HeroPlaceholderImage()
                            }
                                
                            if let imageData = viewModel.secondFavoriteHeroData, let image = UIImage(data: imageData) {
                                Image(uiImage: image).favoriteHeroesModifier()
                            } else {
                                HeroPlaceholderImage()
                            }
                            
                            if let imageData = viewModel.thirdFavoriteHeroData, let image = UIImage(data: imageData) {
                                Image(uiImage: image).favoriteHeroesModifier()
                            } else {
                                HeroPlaceholderImage()
                            }
                        }
                    
                    Picker(selection: $viewModel.selectedHeroIndex, label: Text("Favorite Heroes")) {
                        ForEach(0..<viewModel.dotaHeroesNames.count, id: \.self) { index in
                            Text(viewModel.dotaHeroesNames[index])
                                .foregroundColor(.white)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 250, height: 150)
                    
                    Button {
                        viewModel.fetchFavoriteHeroImages()
                    } label: {
                        CustomButton(buttonTitle: "Select")
                    }.padding(.bottom, 50)
                    
                    Text(viewModel.prompt ?? "")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                    
                    Button {
                        viewModel.checkFields()
                    } label: {
                        CustomButton(buttonTitle: "Save")
                            .opacity(viewModel.fieldsFilled ? 1.0 : 0.5)
                    }

                }
                .padding(.bottom, 50)
            }
            .navigationDestination(isPresented: $viewModel.shouldNavigateToProfileMainView) {
                MainView(selectedTab: .profile)
            }
            .onAppear {
                viewModel.refresh()
            }
            .task {
                viewModel.fetchHeroesNames()
        }
        }
    }
}


struct DotaProfileSetUpSecondView_Previews: PreviewProvider {
    static var previews: some View {
        DotaProfileSetUpSecondView(viewModel: DotaProfileSetUpViewModel())
    }
}
