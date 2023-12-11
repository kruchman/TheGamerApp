//
//  Chat.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 28/11/23.
//

import Foundation

struct Chat: Identifiable, Codable {

    var id: String
    var messages: [Message]
    var users: [UserProfile]
    var justAdded = false
    var nickNames: [String]
    
    static let sample = Chat(id: "asdjkn39fanu39",
                             messages: [Message(id: "fhsd98wrfeh98",
                                                text: "Hello traveler!",
                                                sentBy: "Dendi",
                                                timestamp: Date()),
                                        Message(id: "dsauhj9u3rjhwind",
                                                text: "Hi, nice to meet you!",
                                                sentBy: "Artizi",
                                                timestamp: Date())],
                             users: [UserProfile.sample, UserProfile.sampleTwo], nickNames: [UserProfile.sample.nickName,
                                                                                             UserProfile.sampleTwo.nickName])
}
