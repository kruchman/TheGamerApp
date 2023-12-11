//
//  Chats.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 6/11/23.
//

import SwiftUI

struct ChatsList: View {
    
    @StateObject var viewModel = ChatsViewModel()
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
                .ignoresSafeArea()
            VStack {
                List {
                    ForEach(viewModel.chats, id: \.id) { chat in
                        ChatCell(chat: chat)
                            .listRowBackground(Color("textfield"))
                            .onTapGesture {
                                viewModel.selectedChat = chat
                                viewModel.getMessages()
                                viewModel.isDetailViewShown.toggle()
                            }
                    }
                    .onDelete { indexSet in
                        viewModel.deleteChat(at: indexSet)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(GradientBackgroundView()
                    .ignoresSafeArea())
                .navigationDestination(isPresented: $viewModel.isDetailViewShown) {
                    ChatDetailView()
                        .environmentObject(viewModel)
                }
            }
            if  viewModel.chats.isEmpty {
                GradientBackgroundView()
                    .ignoresSafeArea()
                Text("You have no chats yet")
            }
            if viewModel.dataAreLoading {
                LoadingView()
            }
        }
    }
}

struct ChatsList_Previews: PreviewProvider {
    static var previews: some View {
        ChatsList()
    }
}
