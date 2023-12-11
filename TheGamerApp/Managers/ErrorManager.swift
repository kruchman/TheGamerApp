//
//  ErrorManager.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 8/11/23.
//

import Foundation

enum ErrorManager: Error {
    case badConnection
    case badURL
    case invalidResponse
    case invalidData
    case networkingError
    case transferDataError
    case noCurrentUser
}
