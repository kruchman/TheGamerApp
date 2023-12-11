//
//  ChatCell.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 28/11/23.
//

import SwiftUI
import FirebaseStorage

struct ChatCell: View {
    
    var chat: Chat
    
    var body: some View {
        HStack {
            Text(chat.messages.last?.text ?? "")
            Spacer()
            if !chat.users.isEmpty, let userAvatar = chat.users[0].avatarImage {
                userAvatar
                    .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .shadow(radius: 10)
            } else {    
                ProgressView()
                    .frame(width: 50, height: 50)
            }
        }
        .padding(.horizontal, 30)
        .frame(maxWidth: 350, maxHeight: 50)
        .cornerRadius(50)
    }
}



struct ChatCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatCell(chat: Chat.sample)
    }
}
