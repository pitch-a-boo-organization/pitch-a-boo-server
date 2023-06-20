//
//  DTOSaleResult.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 20/06/23.
//

import Foundation

struct DTOSaleResult: Codable {
    let stage: Int
    let players: [Player]
    let gameEnded: Bool
    let result: SaleResult
}
