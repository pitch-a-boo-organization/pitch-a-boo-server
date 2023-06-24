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
        Item(id: 1, name: "Cérebro do albert einstein", value: 6),
        Item(id: 2, name: "Caneta", value: 3),
        Item(id: 3, name: "Braço que no lugar da mao tem uma motoserra", value: 4),
        Item(id: 4, name: "Abobora falante", value: 3),
        Item(id: 5, name: "Meias listradas com padrões de abóboras e morcegos.", value: 5),
        Item(id: 6, name: "Chapéu de bruxa com uma hélice no topo.", value: 6),
    ].shuffled()
}
