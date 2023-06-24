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
    public let bones: Int
    public let sellingItem: Item
    public let persona: Persona
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
