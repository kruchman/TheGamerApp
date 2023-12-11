//
//  UserAvatarView.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 10/11/23.
//

import SwiftUI

struct UserAvatarPlaceholder: View {

    var body: some View {
        Image("avatar placeholder")
            .userAvatarModifier()
            
    }
}

struct UserAvatarPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        UserAvatarPlaceholder()
    }
}
