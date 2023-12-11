//
//  GameCell.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 11/11/23.
//

import SwiftUI

struct GameCell: View {
    
    var game: Game
    
    var body: some View {
        HStack {
            game.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .shadow(radius: 10)
            Spacer()
            Text(game.name)
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(.black)
            Spacer()
                
        }.padding()
    }
}

struct GameCell_Previews: PreviewProvider {
    static var previews: some View {
        GameCell(game: apex)
    }
}
