//
//  DataManager.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 5/11/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

final class DataManager {
    
    static let shared = DataManager()
    private init() { }
    
    var fireStoreDB = Firestore.firestore()
    var userDotaProfiles: CollectionReference {
        fireStoreDB.collection("User Dota Profiles")
    }
    var chatCollectionReference: CollectionReference {
        fireStoreDB.collection("Chats")
    }
    
    //MARK: - Dota Profile Methods
    
    func fetchDotaProfileData(completion: @escaping (UserProfile?) -> Void) throws {
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            throw ErrorManager.noCurrentUser
        }
        let reference = fireStoreDB.collection("User Dota Profiles").document(user.uid)
        reference.getDocument { snapshot, error in
            guard error == nil else {
                completion(nil)
                return
            }
            if let snapshot = snapshot {
                let userProfile = UserProfile(id: user.uid,
                                              nickName: snapshot["nickName"] as? String ?? "",
                                              rank: snapshot["rank"] as? String ?? "",
                                              position: snapshot["position"] as? String ?? "",
                                              favoriteHeroes: snapshot["favoriteHeroes"] as? [String] ?? [String](),
                                              avatarPath: snapshot["avatarPath"] as? String ?? "")
                completion(userProfile)
            }
        }
    }
    
    func deleteCurrentProfile(avatarPath: String, completion: @escaping (Result<UserProfile, ErrorManager>) -> Void) {
        Task {
            guard let user = Auth.auth().currentUser else {
                completion(.failure(ErrorManager.noCurrentUser))
                return
            }
            do {
                try await StorageManager.shared.deleteAvatar(avatarPath: avatarPath)
                
                let userProfile = UserProfile(id: user.uid,
                                              nickName: "",
                                              rank: "",
                                              position: "",
                                              favoriteHeroes: [String](),
                                              avatarPath: "")
                try  await Firestore.firestore().collection("User Dota Profiles").document(user.uid).updateData(["nickName": "",
                                                                                                                 "rank": "",
                                                                                                                 "position": "",
                                                                                                                 "favoriteHeroes": [String](),
                                                                                                                 "avatarPath": ""])

                Firestore.firestore().collection("Users").whereField("id", isEqualTo: user.uid).getDocuments { querySnapshot, error in
                    if let error = error {
                        completion(.failure(.networkingError))
                        return
                    } else {
                        if let documents = querySnapshot?.documents, !documents.isEmpty {
                            documents[0].reference.updateData(["hasDotaProfile" : false])
                            completion(.success(userProfile))
                        } else {
                            completion(.failure(.networkingError))
                            return
                        }
                    }
                }
            } catch {
                completion(.failure(.networkingError))
            }
        }
    }
    
    func saveUserProfile(nickName: String, rank: String, position: String, favoriteHeroes: [String], avatarPath: String, completion: @escaping (Result<UserProfile, ErrorManager>) -> Void) {
            guard let user = Auth.auth().currentUser else {
                completion(.failure(.noCurrentUser))
                return
            }

        let userProfile = UserProfile(id: user.uid,
                                      nickName: nickName,
                                      rank: rank,
                                      position: position,
                                      favoriteHeroes: favoriteHeroes,
                                      avatarPath: avatarPath)

            do {
                let documentRef = Firestore.firestore().collection("User Dota Profiles").document(user.uid)
                try documentRef.setData(from: userProfile)
                
                Firestore.firestore().collection("Users").whereField("id", isEqualTo: user.uid).getDocuments { querySnapshot, error in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(.failure(.invalidData))
                        return
                    } else {
                        if let documents = querySnapshot?.documents, !documents.isEmpty {
                            documents[0].reference.updateData(["hasDotaProfile" : true])
                            completion(.success(userProfile))
                        } else {
                            completion(.failure(.invalidData))
                            return
                        }
                    }
                }
            } catch {
                completion(.failure(.invalidData))
            }
        }
    
    //MARK: - Chat Methods
    
    func getChats(completion: @escaping ([Chat]) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        var chats = [Chat]()
        var myProfile = UserProfile(id: "")
        var currentUserNickName = ""
        
        let chatsCollection = DataManager.shared.chatCollectionReference
            let dispatchGroup = DispatchGroup()
        
        do {
           try DataManager.shared.fetchDotaProfileData { userProfile in
                if let userProfile = userProfile {
                    myProfile = userProfile
                    
                    chatsCollection.whereField("nickNames", arrayContains: myProfile.nickName).addSnapshotListener { querySnapshot, error in
                    guard error == nil else {
                        print("Error getting chats documents: \(error!.localizedDescription)")
                        completion([])
                        return
                    }
                    
                    guard let querySnapshot = querySnapshot else {
                        print("No chat documents found")
                        completion([])
                        return
                    }
                    
                    for chatDocument in querySnapshot.documents {

                        let messagesCollection = chatDocument.reference.collection("messages")
                        messagesCollection.addSnapshotListener { messagesSnapshot, messagesError in
                            
                            dispatchGroup.enter()

                            var chat = Chat(id: chatDocument.documentID, messages: [], users: [], nickNames: [])
                            chat.nickNames = chatDocument.data()["nickNames"] as? [String] ?? []
                            
                            guard messagesError == nil else {
                                print("Error getting messages documents: \(messagesError!.localizedDescription)")
                                return
                            }

                            guard let messageDocuments = messagesSnapshot?.documents else {
                                print("No message documents found")
                                return
                            }

                            chat.messages = messageDocuments.compactMap { messageDocument -> Message? in
                                try? messageDocument.data(as: Message.self)
                            }
                            chat.messages.sort() { $0.timestamp < $1.timestamp }

                            let userCollection = chatDocument.reference.collection("users")
                            userCollection.getDocuments { userSnapshot, userError in
                                defer {
                                    dispatchGroup.leave()
                                    chats.append(chat)
                                    chats.sort() { $0.messages.last?.timestamp ?? Date() > $1.messages.last?.timestamp ?? Date() }
                                    completion(chats)
                                }
                                guard userError == nil else {
                                    print("Error getting user document: \(userError!.localizedDescription)")
                                    return
                                }

                                guard let userProfileDocuments = userSnapshot?.documents else {
                                    print("No user profile found")
                                    return
                                }

                                chat.users = userProfileDocuments.compactMap { userProfileDocument -> UserProfile? in
                                    try? userProfileDocument.data(as: UserProfile.self)
                                }
                                var indexToDelete = 0
                                for index in chat.users.indices {
                                    if chat.users[index].id == currentUser.uid {
                                        indexToDelete = index
                                    }
                                }
                                if !chat.users.isEmpty {
                                    chat.users.remove(at: indexToDelete)
                                }
                                var secondIndexToDelete: Int?
                                if !chats.isEmpty {
                                    for index in chats.indices {
                                        if chats[index].id == chat.id {
                                            secondIndexToDelete = index
                                        }
                                    }
                                }
                                if secondIndexToDelete != nil {
                                    chats.remove(at: secondIndexToDelete!)
                                }
                                
                            }
                        }
                    }

//                    dispatchGroup.notify(queue: .main) {
//                        chats.sort() { $0.messages.last?.timestamp ?? Date() > $1.messages.last?.timestamp ?? Date() }
//                        completion(chats)
//                    }
                }
                }
            }
        } catch {
            print("Error when fetching chats")
        }
    }
    
    func createNewChat(anotherUserProfile: UserProfile, completion: @escaping (Chat?) -> Void) throws {
        guard let user = Auth.auth().currentUser else {
            throw ErrorManager.noCurrentUser
            completion(nil)
        }
            let chatId = UUID().uuidString
            let chatUserProfilesCollection = chatCollectionReference.document(chatId).collection("users")
            try fetchDotaProfileData { myProfile in
                if let myProfile = myProfile {
                    chatUserProfilesCollection.document(myProfile.id).setData(["avatarPath":myProfile.avatarPath,
                                                                               "favoriteHeroes":myProfile.favoriteHeroes,
                                                                               "id":myProfile.id,
                                                                               "nickName":myProfile.nickName,
                                                                               "position":myProfile.position,
                                                                               "rank":myProfile.rank])
                    
                    chatUserProfilesCollection.document(anotherUserProfile.id).setData(["avatarPath":anotherUserProfile.avatarPath,
                                                                                        "favoriteHeroes":anotherUserProfile.favoriteHeroes,
                                                                                        "id":anotherUserProfile.id,
                                                                                        "nickName":anotherUserProfile.nickName,
                                                                                        "position":anotherUserProfile.position,
                                                                                        "rank":anotherUserProfile.rank])
                    let chat = Chat(id: chatId, messages: [], users: [myProfile, anotherUserProfile], justAdded: true, nickNames: [myProfile.nickName,anotherUserProfile.nickName])
                    self.chatCollectionReference.document(chatId).setData(["id":chatId,
                                                                           "justAdded":true,
                                                                           "nickNames": [myProfile.nickName, anotherUserProfile.nickName]])
                    completion(chat)
                }
            }
    }
    
    func checkIfChatJustAdded(completion: @escaping (Chat?) -> Void) {
               chatCollectionReference.whereField("justAdded", isEqualTo: true).getDocuments { querySnapshot, error in
                   if let error = error {
                       print(error.localizedDescription)
                       completion(nil)
                       return
                   } else {
                       if let documents = querySnapshot?.documents, !documents.isEmpty {
                           documents[0].reference.getDocument { documentSnapshot, error in
                               if let error = error {
                                   print(error.localizedDescription)
                                   completion(nil)
                                   return
                               } else {
                                   let dispatchGroup = DispatchGroup()
                                   if let documentSnapshot = documentSnapshot {
                                       if let data = documentSnapshot.data() {
                                       dispatchGroup.enter()
                                           var chat = Chat(id: "", messages: [], users: [], nickNames: [])
                                       
                                       chat.id = data["id"] as? String ?? ""
                                       chat.justAdded = data["justAdded"] as? Bool ?? false
                                       chat.messages = []
                                       
                                       let usersCollection = documentSnapshot.reference.collection("users")
                                       usersCollection.getDocuments { querySnapshot, error in
                                           defer {
                                               dispatchGroup.leave()
                                           }
                                           if let error = error {
                                               print(error.localizedDescription)
                                               completion(nil)
                                               return
                                           } else {
                                               guard let userProfileDocuments = querySnapshot?.documents else {
                                                   print("No user profile found")
                                                   return
                                               }
                                               chat.users = userProfileDocuments.compactMap { userProfileDocument -> UserProfile? in
                                                   do {
                                                      return try userProfileDocument.data(as: UserProfile.self)
                                                   } catch {
                                                       print("Error fetching profiles")
                                                       return nil
                                                   }
                                               }
                                           }
                                       }
                                       dispatchGroup.notify(queue: .main) {
                                           chat.nickNames = [chat.users[0].nickName, chat.users[1].nickName]
                                           completion(chat)
                                       }
                                   }
                                   }
                               }
                           }
                       }
                   }
               }
       }
    
    func makeJustAddedFalse(completion: @escaping () -> Void) {
            chatCollectionReference.whereField("justAdded", isEqualTo: true).getDocuments { querySnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion()
                } else {
                    if let documents = querySnapshot?.documents, !documents.isEmpty {
                        documents[0].reference.updateData(["justAdded" : false])
                        completion()
                    }
                }
            }
        completion()
    }
    
    func checkForChatExistence(anotherUserProfile: UserProfile, completion: @escaping (Chat?) -> Void) {
        do {
            try fetchDotaProfileData { myProfile in
            if let myProfile = myProfile {

            let firstQuery = self.chatCollectionReference
                .whereField("nickNames", arrayContains: myProfile.nickName)
            
            let secondQuery = self.chatCollectionReference
                .whereField("nickNames", arrayContains: anotherUserProfile.nickName)
            
            firstQuery.getDocuments { firstQuerySnapshot, firstQueryError in
                secondQuery.getDocuments { secondQuerySnapshot, secondQueryError in
                    if let error = firstQueryError ?? secondQueryError {
                        print(error.localizedDescription)
                        completion(nil)
                        return
                    }
                    
                    let firstDocuments = firstQuerySnapshot?.documents ?? []
                    let secondDocuments = secondQuerySnapshot?.documents ?? []
                    
                    let commonDocuments = firstDocuments.filter { secondDocuments.contains($0) }
                    
                    if let commonDocument = commonDocuments.first {
                        let chat = Chat(id: commonDocument.data()["id"] as? String ?? "",
                                        messages: commonDocument.data()["messages"] as? [Message] ?? [],
                                        users: commonDocument.data()["users"] as? [UserProfile] ?? [],
                                        justAdded: commonDocument.data()["justAdded"] as? Bool ?? false,
                                        nickNames: commonDocument.data()["nickNames"] as? [String] ?? [])
                        completion(chat)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
        } catch {
            print("Error fetching dota profile data in checkForChatExistence method")
        }
    }

    func deleteChat(chatToDelete: Chat) {
        let chatToDeleteDocument = chatCollectionReference.document(chatToDelete.id)
        chatToDeleteDocument.delete()
    }
    
}
