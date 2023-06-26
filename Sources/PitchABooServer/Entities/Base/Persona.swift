//
//  File.swift
//  
//
//  Created by Thiago Henrique on 19/06/23.
//

import Foundation

public struct Persona: Codable {
    public let id: Int
    public let name: String
    public let characteristics: [Characteristic]
}

extension Persona {
    public static let availablePersonas: [Persona] = [
        Persona(
            id: 1,
            name: "Werewolf",
            characteristics: [.extroverted, .collectionner, .athletic]
        ),
        Persona(
            id: 2,
            name: "Vampire",
            characteristics: [.gothic, .collectionner, .vegan]
        ),
        Persona(
            id: 3,
            name: "Frankenstein",
            characteristics: [.playful, .introvert, .fashionable]
        ),
        Persona(
            id: 4,
            name: "Zombie",
            characteristics: [.dumb, .extroverted, .oldFashioned]
        ),
        Persona(
            id: 5,
            name: "Invisible Man",
            characteristics: [.workaholic, .fashionable, .oldFashioned]
        ),
        Persona(
            id: 6,
            name: "Ghost",
            characteristics: [.gothic, .playful, .introvert]
        ),
        Persona(
            id: 7,
            name: "Lake Monster",
            characteristics: [.extroverted, .playful, .athletic]
        )
    ].shuffled()
}
