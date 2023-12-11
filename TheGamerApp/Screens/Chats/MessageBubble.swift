//
//  MessageBubble.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 1/12/23.
//

import SwiftUI

struct MessageBubble: View {
    
    var userProfile: UserProfile
    var message: Message
    @State private var showTime = false
    
    var body: some View {
        VStack(alignment: userProfile.nickName == message.sentBy ? .trailing : .leading) {
            HStack {
                Text(message.text)
                    .padding()
                    .background(userProfile.nickName == message.sentBy ? Color("MessageRecieved") : Color("MessageSent"))
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: userProfile.nickName == message.sentBy ? .trailing : .leading)
            .onTapGesture {
                showTime.toggle()
            }
            if showTime {
                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(userProfile.nickName == message.sentBy ? .trailing : .leading, 25)
            }
        }
        .frame(maxWidth: .infinity, alignment: userProfile.nickName == message.sentBy ? .trailing : .leading)
        .padding(userProfile.nickName == message.sentBy ? .trailing : .leading)
        .padding(.horizontal, 10)
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(userProfile: UserProfile.sample, message: Message(id: "12345", text: "Hello traveler!", sentBy: "Dendi", timestamp: Date()))
    }
}
