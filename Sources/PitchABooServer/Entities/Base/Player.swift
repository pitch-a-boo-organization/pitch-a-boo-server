//
//  File.swift
//  
//
//  Created by Thiago Henrique on 19/06/23.
//

import Foundation

public struct Player: Codable {
    public let id: Int
    public let name: String
    public var bones: Int
    public let sellingItem: Item
    public let persona: Persona
}

extension Player {
    static func createAnUndefinedPlayer() -> Player {
        Player(id: 0, name: "Undefined", bones: 0, sellingItem: Item(id: 0, name: "None", value: 0, characteristc: .athletic), persona: Persona(id: 0, name: "None", characteristics: [.dumb]))
    }
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
