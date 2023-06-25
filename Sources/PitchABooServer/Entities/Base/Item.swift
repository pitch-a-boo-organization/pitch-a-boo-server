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
}

extension Item {
    static let availableItems: [Item] = [
        Item(id: 1, name: "Mad Scientist Brain", value: 6),
        Item(id: 2, name: "Pen", value: 3),
        Item(id: 3, name: "Chainsaw Hand", value: 4),
        Item(id: 4, name: "Pumpkin", value: 3),
        Item(id: 5, name: "Comfy Socks", value: 5),
        Item(id: 6, name: "Witch Hat", value: 6),
    ].shuffled()
}
