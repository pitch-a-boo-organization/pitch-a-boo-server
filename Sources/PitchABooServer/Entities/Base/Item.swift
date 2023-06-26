//
//  File.swift
//  
//
//  Created by Thiago Henrique on 19/06/23.
//

import Foundation

public struct Item: Codable {
    public let id: Int
    public let name: String
    public let value: Int
    public let characteristc: Characteristic
}

extension Item {
    static let availableItems: [Item] = [
        Item(id: 1, name: "Mad Scientist Brain", value: 6, characteristc: .collectionner),
        Item(id: 2, name: "Pen", value: 3, characteristc: .collectionner),
        Item(id: 3, name: "Chainsaw Hand", value: 4, characteristc: .extroverted),
        Item(id: 4, name: "Pumpkin", value: 3, characteristc: .playful),
        Item(id: 5, name: "Comfy Socks", value: 5, characteristc: .playful),
        Item(id: 6, name: "Witch Hat", value: 6, characteristc: .extroverted),
    ].shuffled()
}
