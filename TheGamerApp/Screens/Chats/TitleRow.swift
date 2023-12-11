//
//  TitleRow.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 1/12/23.
//

import SwiftUI

struct TitleRow: View {
    
    var avatar: Image?
    var nickName: String
    
    var body: some View {
        HStack(spacing: 5) {
            Text(nickName)
                .font(.title2)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
            
            if let avatar = avatar {
                avatar
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80,alignment: .trailing)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .offset(x: -50)
            } else {
                ProgressView()
            }
        }
        .frame(height: 100)
        .padding()
    }
}

struct TitleRow_Previews: PreviewProvider {
    static var previews: some View {
        TitleRow(avatar: Image("avatar placeholder"), nickName: "Yurizi")
            .background(Color("thirdBackgroundColor"))
    }
}
