//
//  File.swift
//  
//
//  Created by Joan Wilson Oliveira on 26/06/23.
//

import Foundation

public enum Characteristic: String, Codable {
    case extroverted = "Extroverted"
    case collectionner = "Collectionner"
    case athletic = "Athletic"
    case gothic = "Gothic"
    case vegan = "Vegan"
    case playful = "Playful"
    case introvert = "Introvert"
    case fashionable = "Fashionable"
    case dumb = "Dumb"
    case oldFashioned = "Old-Fashioned"
    case workaholic = "Workaholic"
    
    var stringValue: String {
        return self.rawValue
    }
}
