//
//  File.swift
//  
//
//  Created by Thiago Henrique on 19/06/23.
//

import Foundation

struct Item: Codable {
    let id: Int
    let name: String
    let bonusScore: Int
    let persona: Persona
    let value: Int
}

extension Item {
    static var availableItems: [Item] = []
}
