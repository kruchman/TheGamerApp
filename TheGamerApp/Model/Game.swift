//
//  Game.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 11/11/23.
//

import SwiftUI

struct Game: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let image: Image
}

let dota = Game(name: "Dota 2", image: Image("DotaLogo"))
let cs = Game(name: "Counter Strike", image: Image("CSLogo"))
let apex = Game(name: "Apex Legends", image: Image("ApexLogo"))
let lol = Game(name: "Leage Of Legends", image: Image("LolLogo"))
let overwatch = Game(name: "Overwatch", image: Image("OverwatchLogo"))
let valorant = Game(name: "Valorant", image: Image("ValorantLogo"))

var games: [Game] = [dota, cs, apex, lol, overwatch, valorant]
