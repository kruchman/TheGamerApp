//
//  ChatDetailView.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 1/12/23.
//

import SwiftUI

struct ChatDetailView: View {
    
    @EnvironmentObject var viewModel: ChatsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            VStack {
                TitleRow(avatar: viewModel.selectedChat?.users[0].avatarImage ?? Chat.sample.users[0].avatarImage,
                         nickName: viewModel.selectedChat?.users[0].nickName ?? Chat.sample.users[0].nickName)
                .background(GradientBackgroundView()
                    .ignoresSafeArea())
                
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(viewModel.messages, id: \.id) { message in
                            MessageBubble(userProfile: viewModel.selectedChat?.users[0] ?? Chat.sample.users[0],
                                          message: message)
                        }
                    }
                    .padding(.top, 10)
                    .background(.white)
                    
                    .onAppear {
                        withAnimation {
                            proxy.scrollTo(viewModel.lastMessageId, anchor: .bottom)
                        }
                    }
                    .onChange(of: viewModel.lastMessageId) { id in
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                }
            }
            
            MessageTextField()
                .environmentObject(viewModel)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    DataManager.shared.makeJustAddedFalse {
                        DataManager.shared.getChats { chats in
                            viewModel.chats = chats
                            viewModel.fetchAvatars()
                            dismiss()
                        }
                    }
                } label: {
                    CustomBackButton()
                        .foregroundColor(.white)
                }

            }
        }
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChatDetailView()
            .environmentObject(ChatsViewModel())
    }
}
