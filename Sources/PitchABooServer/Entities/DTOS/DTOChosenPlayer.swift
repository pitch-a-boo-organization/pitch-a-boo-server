//
//  DTOChosenPlayer.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 20/06/23.
//

import Foundation

struct DTOChosenPlayer: Codable {
    let stage: Int
    let player: Player
    let item: Item
}
