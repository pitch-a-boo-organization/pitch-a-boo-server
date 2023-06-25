//
//  File.swift
//  
//
//  Created by Thiago Henrique on 22/06/23.
//

import Foundation

public struct SaleResult: Codable {
    public let item: Item
    public let soldValue: Int
    public let seller: Player
    public let buyer: Player
}
