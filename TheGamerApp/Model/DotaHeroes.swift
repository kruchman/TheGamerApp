//
//  DotaHeroes.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 8/11/23.
//

import Foundation

struct DotaHero: Codable {
    let id: Int
    let name: String
    let localized_name: String
    let primary_attr: String
    let attack_type: String
    let roles: [String]
    let legs: Int
}

typealias DotaHeroes = [DotaHero]

