//
//  DotaProfileViewModel.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 18/11/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

final class DotaProfileViewModel: ObservableObject {
    
    @Published var userHasDotaProfile: Bool = false
    @Published var dataAreLoading = false
    var userId = ""
    
    init() {
        dataAreLoading = true
        if let currentUserID = Auth.auth().currentUser?.uid {
            userId = currentUserID

            Firestore.firestore().collection("Users").whereField("id", isEqualTo: currentUserID).getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    if let documents = querySnapshot?.documents, !documents.isEmpty {
                        let hasDotaProfile = documents[0].data()["hasDotaProfile"] as? Bool ?? false
                        self.userHasDotaProfile = hasDotaProfile
                        self.dataAreLoading = false
                    } else {
                        self.userHasDotaProfile = false
                        self.dataAreLoading = false
                    }
                }
            }
        }
    }
    
}
