//
//  Message.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 28/11/23.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var sentBy: String
    var timestamp: Date
    
    static let sample = [Message(id: "123", text: "Hello!", sentBy: "Dendi", timestamp: Date()),
                         Message(id: "12345", text: "How are you?", sentBy: "Dendi", timestamp: Date())]
}
