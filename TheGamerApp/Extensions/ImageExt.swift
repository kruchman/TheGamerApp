//
//  ImageExt.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 9/11/23.
//

import SwiftUI

extension Image {

    func favoriteHeroesModifier() -> some View {
        self.resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
    }
    func userAvatarModifier() -> some View {
        self.resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipShape(Circle())
            .shadow(radius: 10)
    }
}
