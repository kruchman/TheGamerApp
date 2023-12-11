//
//  StorageManager.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 8/11/23.
//

import SwiftUI
import FirebaseStorage
import UIKit

final class StorageManager {
    static let shared = StorageManager()
    private init() { }
    
    private let storage = Storage.storage().reference()
    
    private var usersPhotos: StorageReference  {
        storage.child("Users Photos")
    }
    
    private var dotaHeroesImages: StorageReference {
        storage.child("Dota Heroes")
    }
    
    //MARK: - Save Methods
    
    var userAvatarPath: String?

    func saveImage(data: Data) async throws -> (path: String, name: String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetadata = try await usersPhotos.child(path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetadata.path, let returnedName = returnedMetadata.name else {
            throw ErrorManager.invalidData
        }
        userAvatarPath = returnedName
        return (returnedPath, returnedName)
    }
    
    func saveImage(image: UIImage) async throws -> (path: String, name: String) {
        guard let data = image.jpegData(compressionQuality: 1) else {
            throw ErrorManager.invalidData
        }
        return try await saveImage(data: data)
    }
    
    //MARK: - Get Methods
    
    func getData(heroName: String) async throws -> Data {
            try await dotaHeroesImages.child(heroName).data(maxSize: 3 * 1024 * 1024)
    }
    
    func fetchUserPhoto(userPhotoPath: String) async throws -> Data {
        try await usersPhotos.child(userPhotoPath).data(maxSize: 3 * 1024 * 1024)
    }
    
    //MARK: - Delete Methods
    
    func deleteAvatar(avatarPath: String) async throws {
        try await usersPhotos.child(avatarPath).delete()
        userAvatarPath = nil
    }

}
