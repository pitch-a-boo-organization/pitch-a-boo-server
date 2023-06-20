//
//  DTOVerifyAvailability.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 20/06/23.
//

import Foundation

struct DTOVerifyAvailability: Codable {
    let stage: Int
    let available: Bool
}

struct SaleResult: Codable {
    let winner: Player
    let price: Double
}

