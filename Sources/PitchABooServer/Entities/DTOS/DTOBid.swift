//
//  DTOBid.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 20/06/23.
//

import Foundation

struct DTOBid: Codable {
    let stage: Int
    let bid: Int
    let player: Player
}
