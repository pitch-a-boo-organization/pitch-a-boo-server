//
//  File.swift
//  
//
//  Created by Thiago Henrique on 19/06/23.
//

import Foundation

struct Persona: Codable {
    let id: Int
    let name: String
    let perk: String
}

extension Persona {
    static var availablePersonas: [Persona] = [
        Persona(
            id: 1,
            name: "Zumbi",
            perk: ""
        )
    ]
}
