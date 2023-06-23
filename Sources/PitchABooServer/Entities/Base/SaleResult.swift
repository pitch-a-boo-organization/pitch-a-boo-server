//
//  File.swift
//  
//
//  Created by Thiago Henrique on 22/06/23.
//

import Foundation

public struct SaleResult: Codable {
    let item: Item
    let soldValue: Int
    let seller: Player
    let buyer: Player
}
