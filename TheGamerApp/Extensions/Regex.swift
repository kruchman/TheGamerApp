//
//  Regex.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 3/11/23.
//

import Foundation

enum Regex: String {
    case email = "^[a-zA-Z0-9_]{3,20}$"
    case password = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$"
}
