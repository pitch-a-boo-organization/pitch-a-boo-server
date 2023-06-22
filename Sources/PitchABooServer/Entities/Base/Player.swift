//
//  File.swift
//  
//
//  Created by Thiago Henrique on 19/06/23.
//

import Foundation

struct Player: Codable {
    let id: Int
    let name: String
    let bones: Int
    let sellingItem: Item
    let persona: Persona
}

extension Player {
    static let availableNames = [
        "FullMoon",
        "NailHead",
        "GraveMan",
        "ToiletGuy",
        "Translucid",
        "SharpTooth",
        "Lilypad",
        "FrostByte",
        "StoneGrip",
        "GhostWhisper",
        "SparkSlash",
        "BloodMoon"
    ].shuffled()
}
