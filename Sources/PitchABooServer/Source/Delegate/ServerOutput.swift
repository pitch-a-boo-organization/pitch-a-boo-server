//
//  File.swift
//  
//
//  Created by Thiago Henrique on 23/06/23.
//

import Foundation

public protocol ServerOutputs: AnyObject {
    func didConectPlayer(players: [Player])
    func didDefineSellingPlayer(_ player: Player)
    func inningEnd(players: [Player], gameEnded: Bool, result: SaleResult)
}
