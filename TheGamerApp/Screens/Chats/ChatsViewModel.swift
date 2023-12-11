//
//  ChatsViewModel.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 28/11/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

@MainActor final class ChatsViewModel: ObservableObject {
    
    var userProfile: UserProfile?
    @Published var chats: [Chat] = []
    @Published private(set) var messages: [Message] = []
    @Published private(set) var lastMessageId = ""  
    @Published var selectedChat: Chat?
    @Published var isDetailViewShown = false
    @Published var dataAreLoading = false
    
    let db = Firestore.firestore()
    
    init() {
        dataAreLoading = true
        do {
            try DataManager.shared.fetchDotaProfileData(completion: { userProfile in
                if let userProfile = userProfile {
                    self.userProfile = userProfile
                }
            })
        } catch {
            print("Catching errors in chats view mdoel init")
        }
        DataManager.shared.getChats { chats in
            if chats != nil {
                self.checkIfChatJustAdded()
                self.chats = chats
                self.fetchAvatars()
                self.dataAreLoading = false
            } else {
                self.dataAreLoading = false
            }
        }
    }
    
    func getMessages() {
        guard let selectedChat = selectedChat else {
            print("No selected chat to send message")
            return
        }
        let messagesCollection = DataManager.shared.chatCollectionReference.document(selectedChat.id).collection("messages")
        messagesCollection.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            self.messages = documents.compactMap { document -> Message? in
                do {
                    return try document.data(as: Message.self)
                } catch {
                    print("Error decoding document into Message: \(error)")
                    return nil
                }
            }
            self.messages.sort { $0.timestamp < $1.timestamp }
            
            if let lastMessageId = self.messages.last?.id {
                self.lastMessageId = lastMessageId
            }
            self.dataAreLoading = false 
        }
    }
    
    func fetchAvatars() {
        Task {
            var chatsNew = chats 
                for index in chatsNew.indices {
                    if !chatsNew[index].users.isEmpty {
                        chatsNew[index].users[0].avatarData = try? await StorageManager.shared.fetchUserPhoto(userPhotoPath: chatsNew[index].users[0].avatarPath)
                    }
                }
                chats = chatsNew
        }
    }
    
    
    func getLastMessageId(chat: Chat) {
        if let lastMessageId = chat.messages.last?.id {
            self.lastMessageId = lastMessageId  
        }
    }
    
    
    func sendMessage(text: String, myNickname: String) {
        guard let selectedChat = selectedChat else {
            print("No selected chat to send message")
            return
        }
        let newMessage = Message(id: UUID().uuidString,
                                 text: text,
                                 sentBy: myNickname,
                                 timestamp: Date())

        let messagesCollection = DataManager.shared.chatCollectionReference.document(selectedChat.id).collection("messages")

        do {
            try messagesCollection.document().setData(from: newMessage)
        } catch {
            print("Error adding message to Firestore \(error.localizedDescription)")
        }
    }
    
    func checkIfChatJustAdded() {
        guard let currentUser = Auth.auth().currentUser else {
            print("НЕТ ТЕКУЩЕГО ЮЗЕРА")
            return
        }
        DataManager.shared.checkIfChatJustAdded { chat in
            if var chat = chat {
                var indexToDelete = 0
                for index in chat.users.indices {
                    if chat.users[index].id == currentUser.uid {
                        indexToDelete = index
                    }
                }
                chat.users.remove(at: indexToDelete)
                self.selectedChat = chat
                self.getMessages()
                self.isDetailViewShown.toggle()
            } else {
                return
            }
        }
    }

    func deleteChat(at offsets: IndexSet) {
        let chatToDelete = chats[offsets.first!]
        DataManager.shared.deleteChat(chatToDelete: chatToDelete)
        chats.remove(atOffsets: offsets)
        DataManager.shared.getChats { chats in
            self.chats = chats
            self.fetchAvatars()
        }
       }
    
}

