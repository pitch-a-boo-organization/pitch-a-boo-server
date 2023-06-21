//
//  File.swift
//  
//
//  Created by Thiago Henrique on 21/06/23.
//

import Foundation

class GameSession {
    private var hasSelling: [Player] = []
    private(set) var gameHasStarted = false
    var players: [Player] = []
    
    func chooseSellingPlayer() -> Player? {
        for player in players {
            if !hasSelling.contains(where: { $0.id == player.id }) {
                return player
            }
        }
        return nil
    }
    
    func startGame() {
        gameHasStarted.toggle()
    }
}
