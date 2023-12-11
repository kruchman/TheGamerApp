//
//  TheGamerAppApp.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 1/11/23.
//

import SwiftUI
import Firebase

@main
struct TheGamerApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                EnterView()
            }
            .tint(.white)
        }
    }
}

