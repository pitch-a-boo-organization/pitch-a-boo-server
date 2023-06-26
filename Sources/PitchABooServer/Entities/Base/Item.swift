//
//  File.swift
//  
//
//  Created by Thiago Henrique on 19/06/23.
//

import Foundation

import Foundation

public struct Item: Codable, Hashable {
    public let id: Int
    public let name: String
    public let value: Int
    public let characteristic: Characteristic
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(value)
        hasher.combine(characteristic)
    }
}

extension Item {
    public static let availableItems: [Item] = [
        Item(id: 1, name: "Mad Scientist Brain", value: 6, characteristic: .collectionner),
        Item(id: 2, name: "Pen", value: 3, characteristic: .collectionner),
        Item(id: 3, name: "Chainsaw Hand", value: 4, characteristic: .extroverted),
        Item(id: 4, name: "Pumpkin", value: 3, characteristic: .playful),
        Item(id: 5, name: "Comfy Socks", value: 5, characteristic: .playful),
        Item(id: 6, name: "Witch Hat", value: 6, characteristic: .extroverted),
    ].shuffled()
}
