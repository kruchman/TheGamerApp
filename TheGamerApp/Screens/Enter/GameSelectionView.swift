//
//  Profile.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 6/11/23.
//

import SwiftUI


struct GameSelectionView: View {
    
    @StateObject var viewModel = GameSelectionViewModel()
    
    var body: some View {
            List {
                ForEach(games) { game in
                    NavigationLink(destination: GameSelectionLogic(game: game)) {
                        GameCell(game: game)
                    }
                    .listRowBackground(GradientBackgroundView()
                        .opacity(0.7))
                    .listRowSeparatorTint(.white)
                }
            }
            .scrollContentBackground(.hidden)
            .background(GradientBackgroundView())
            .ignoresSafeArea()
            .navigationBarBackButtonHidden()
    }
}

struct GameSelectionLogic: View {
    var game: Game
    var body: some View {
        switch game {
        case dota: MainView()
        default: ComingSoonView()
        }
    }
}

struct GameSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        GameSelectionView()
    }
}
