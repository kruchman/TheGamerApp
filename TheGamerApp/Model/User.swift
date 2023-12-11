//
//  User.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 17/11/23.
//

import SwiftUI

struct User: Codable, Identifiable {
    static var shared = User()
    private init() { }
    
    var id: String = ""
    var isLoggedIn = false
    var isOnline = false
    var hasDotaProfile = false
}
