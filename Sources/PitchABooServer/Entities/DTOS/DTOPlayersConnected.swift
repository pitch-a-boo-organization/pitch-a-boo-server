//
//  DTOPlayersConnected.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 20/06/23.
//

import Foundation

struct DTOPlayersConnected: Codable {
    let stage: Int
    let players: [Player]
}
