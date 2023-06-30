//
//  File.swift
//  
//
//  Created by Thiago Henrique on 21/06/23.
//

import Foundation

public class GameSession {
    public var players: [Player]
    public private (set) var hasSelling: [Player] = []
    public private (set) var currentSellingPlayer: Player?
    public private(set) var inningBids: [(bid: Int, from: Player)] = []
    public private(set) var gameHasStarted = false
    public var gameEnded: Bool {
        get {
            return hasSelling.count == players.count
        }
    }
    internal var pausedPlayers: [Player] = []
    
    init(players: [Player]) { self.players = players }
    
    func chooseSellingPlayer() -> Player? {
        for player in players {
            if !hasSelling.contains(where: { $0.id == player.id }) {
                hasSelling.append(player)
                currentSellingPlayer = player
                return player
            }
        }
        return nil
    }
    
    func startGame() { gameHasStarted.toggle() }
    
    func receive(bid: Int, from player: Player, finishBids: (() -> Void)?) {
        inningBids.append((bid, player))
    }
    
    func finishInning() -> SaleResult? {
        if !inningBids.isEmpty {
            let winnerBid = inningBids.min(by: { $0.bid < $1.bid } )
            if let sellingPlayer = currentSellingPlayer {
                return SaleResult(
                    item: sellingPlayer.sellingItem,
                    soldValue: winnerBid!.bid,
                    seller: sellingPlayer,
                    buyer: winnerBid!.from
                )
            }
        }
        return nil
    }
}
