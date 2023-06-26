//
//  File.swift
//  
//
//  Created by Thiago Henrique on 19/06/23.
//

import Foundation

public struct Player: Codable, Hashable, Equatable {
    let id: Int
    let name: String
    let bones: Int
    let sellingItem: Item
    let persona: Persona
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(bones)
        hasher.combine(sellingItem)
    }
    
    public static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.bones == rhs.bones &&
            lhs.sellingItem == rhs.sellingItem
    }
}

extension Player {
    static func createAnUndefinedPlayer() -> Player {
        Player(id: 0, name: "Undefined", bones: 0, sellingItem: Item(id: 0, name: "None", value: 0, characteristic: .athletic), persona: Persona(id: 0, name: "None", characteristics: [.dumb]))
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
