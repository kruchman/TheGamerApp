//
//  GameSelectionView.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 3/11/23.
//

import SwiftUI
import Firebase

struct MainView: View {
    
    @AppStorage("user") var user: Data?
    @State private var shouldNavigateToEnterView = false
    @State var selectedTab: Tab = .usersList
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        TabView(selection: $selectedTab) {
                UsersList()
                    .tag(Tab.usersList)
                    .tabItem {
                        Label("Players", systemImage: "gamecontroller.fill")
                    }
                ChatsList()
                    .tag(Tab.chats)
                    .tabItem {
                        Label("Chats", systemImage: "bubble.left.fill")
                    }
                Favorites()
                    .tag(Tab.favorites)
                    .tabItem {
                        Label("Favorites", systemImage: "bolt.heart.fill")
                    }
                
                DotaProfileView()
                    .tag(Tab.profile)
                    .tabItem {
                        Label("Profile", systemImage: "person.circle.fill")
                    }   
            }
            .tint(.white)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        do {
                            try Auth.auth().signOut()
                            User.shared.isOnline = false
                            User.shared.isLoggedIn = false
                            let encodedUserData = try JSONEncoder().encode(User.shared)
                            user = encodedUserData
                            
                            shouldNavigateToEnterView.toggle()
                        } catch {
                            print("Occurred error while signing out")
                        }
                    } label: {
                        LogOutButton()
                            .frame(width: 65, height: 65)
                    }
                    
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                dismiss()
                            } label: {
                                CustomBackButton()
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    .navigationDestination(isPresented: $shouldNavigateToEnterView) {
                        EnterView()
                    }
                }
            }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

enum Tab {
    case usersList
    case chats
    case favorites
    case profile
}
