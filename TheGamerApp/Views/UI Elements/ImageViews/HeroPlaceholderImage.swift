//
//  HeroPlaceholderImage.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 9/11/23.
//

import SwiftUI

struct HeroPlaceholderImage: View {

    var body: some View {
        Image("Hero Placeholder")
            .favoriteHeroesModifier()
    }
}

struct HeroPlaceholderImage_Previews: PreviewProvider {
    static var previews: some View {
        HeroPlaceholderImage()
    }
}
