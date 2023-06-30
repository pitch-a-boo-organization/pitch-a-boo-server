//
//  File.swift
//  
//
//  Created by Thiago Henrique on 29/06/23.
//

import Foundation

struct DTOUpdatePlayers: Codable {
    let stage: Int
    let players: [Player]
}
