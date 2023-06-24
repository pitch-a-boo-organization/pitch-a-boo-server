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
    public let characteristics: [String]
}

extension Persona {
    static let availablePersonas: [Persona] = [
        Persona(
            id: 1,
            name: "Werewolf",
            characteristics: [
                "Extroverted",
                "Collectionner",
                "Athletic"
            ]
        ),
        Persona(
            id: 2,
            name: "Vampire",
            characteristics: [
                "Gothic",
                "Collectionner",
                "Vegan"
            ]
        ),
        Persona(
            id: 3,
            name: "Frankenstein",
            characteristics: [
                "Playful",
                "Introvert",
                "Fashionable"
            ]
        ),
        Persona(
            id: 4,
            name: "Zombie",
            characteristics: [
                "Dumb",
                "Extroverted",
                "Old-Fashioned"
            ]
        ),
        Persona(
            id: 5,
            name: "Mummy",
            characteristics: [
                "Workaholic",
                "Fashionable",
                "Old-Fashioned"
            ]
        ),
        Persona(
            id: 6,
            name: "Ghost",
            characteristics: [
                "Gothic",
                "Playful",
                "Introvert"
            ]
        ),
        Persona(
            id: 7,
            name: "Lake Monster",
            characteristics: [
                "Extroverted",
                "Playful",
                "Athletic"
            ]
        )
    ].shuffled()
}
